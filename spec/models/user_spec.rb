require 'spec_helper'

describe User do
  it "has manu access_tokens" do
    u = User.new
    access_tokens_medth = ABSTRACT(:access_token_plur)
    info = "(#{access_tokens_medth}) user : #{u.inspect}"
    
    assert u.send(access_tokens_medth), info
    assert u.respond_to?(access_tokens_medth), info
  end
  
  it { should respond_to ABSTRACT(:access_token_plur) }
  it { should respond_to ABSTRACT(:authorization_code_plur) }
end
