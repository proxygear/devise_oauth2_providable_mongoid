require 'spec_helper'

describe ABSTRACT(:client) do
  #it { ABSTRACT(:client).table_name.should == ABSTRACT(:client_plur).to_s }

  describe 'basic client instance' do
    with :client
    subject { client }
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should allow_mass_assignment_of :name }
    it { should validate_presence_of :website }
    it { should allow_mass_assignment_of :website }
    it { should allow_mass_assignment_of :redirect_url }
    it { should validate_uniqueness_of :app_identifier }
    it { should have_index_for(:app_identifier) } #.with_options(:unique => true)
    it { should_not allow_mass_assignment_of :app_identifier }
    it { should_not allow_mass_assignment_of :secret }
    it { should have_many ABSTRACT(:refresh_token_plur) }
    it { should have_many ABSTRACT(:authorization_code_plur) }
  end
end
