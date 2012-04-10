module ModelAbstraction
  module SharedMethods
    def ABSTRACT meth=nil
      if meth
        ::Devise::Oauth2Providable.models.send meth
      else
        ::Devise::Oauth2Providable.models
      end
    end
  end

  def self.included base
    base.send :include, SharedMethods
    base.send :extend, SharedMethods
  end
end

include ModelAbstraction

puts ModelAbstraction::SharedMethods.ABSTRACT
puts ABSTRACT()