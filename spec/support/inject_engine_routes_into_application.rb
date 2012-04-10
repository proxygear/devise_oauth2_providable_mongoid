# see http://www.builtfromsource.com/2011/09/21/testing-routes-with-rails-3-1-engines/
module Devise
  module Oauth2Providable
    module EngineHacks
      ##
      # Automatically append all of the current engine's routes to the main
      # application's route set. This needs to be done for ALL functional tests that
      # use engine routes, since the mounted routes don't work during tests.
      #
      # @param [Symbol] engine_symbol Optional; if provided, uses this symbol to
      #   locate the engine class by name, otherwise uses the module of the calling
      #   test case as the presumed name of the engine.
      # 
      # @author Jason Hamilton (jhamilton@greatherorift.com)
      # @author Matthew Ratzloff (matt@urbaninfluence.com)
      def load_engine_routes(engine_symbol = nil)
        if engine_symbol
          engine_name = engine_symbol.to_s.camelize
        else
          # No engine provided, so presume the current engine is the one to load
          engine_name = self.class.name.split("::").first.split("(").last
        end
        engine = ("#{engine_name}::Engine").constantize

        engine_name = 'oauth2'
        engine = Devise::Oauth2Providable::Engine
        named_routes   = engine.routes.named_routes.routes
        resourced_routes = []

        # Append the routes for this module to the existing routes
        # ::Rails.application.routes.disable_clear_and_finalize = true
        # ::Rails.application.routes.clear!
        # ::Rails.application.routes_reloader.paths.each { |path| load(path) }
        ::Rails.application.routes.draw do

          # unnamed_routes = engine.routes.routes - named_routes.values

          engine.routes.routes.each do |route|
            # Call the method by hand based on the symbol
            pre_path = route.path
            if pre_path.kind_of?(Journey::Path::Pattern) # seams that complexe types are now in use
              path = pre_path = "/#{engine_name.underscore}#{pre_path.spec.to_s}"
            else
              path = "/#{engine_name.underscore}#{pre_path}"
            end
            requirements = route.requirements
            if path_helper = named_routes[route]
              requirements[:as] = path_helper
            elsif route.requirements[:controller].present?
              # Presume that all controllers referenced in routes should also be
              # resources and append that routing on the end so that *_path helpers
              # will still work
              resourced_routes << route.requirements[:controller].gsub("#{engine_name.downcase}/", "").to_sym
            end

            pre_verb = (route.verb.blank? ? "GET" : route.verb)
            
            if pre_verb.to_s == "(?-mix:)"
              verb = :all
            elsif pre_verb.to_s == "(?-mix:^POST$)"
              verb = :post
            else
              raise "not handled verb : #{pre_verb}"
            end
            
            puts "GENERATE PATH : #{verb} #{path} #{requirements} for route #{route.name}"

            if verb == :all
              send(:match, path, requirements)
            else
              send(verb, path, requirements)
            end
          end
  
          # Add each route, once, to the end under a scope to trick path helpers.
          # This will probably break as soon as there is route name overlap, but
          # we'll cross that bridge when we get to it.
          # resourced_routes.uniq!
          # scope engine_name.downcase do
          #   resourced_routes.each do |resource|
          #     resources resource
          #   end
          # end
        end

        # Finalize the routes
        ::Rails.application.routes.finalize!
        ::Rails.application.routes.disable_clear_and_finalize = false
      end
    end
  end
end

Rails::Engine.send(:include, Devise::Oauth2Providable::EngineHacks)
