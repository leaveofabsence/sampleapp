require 'spec_helper'

describe UsersHelper do

  describe 'gravatar_for' do
    let(:user) { FactoryGirl.create(:user)}

    it 'should generate an img tag with the gravatar url' do
      gravatar_for(user).should =~ /<img alt="Person 1" class="gravatar" src="https:\/\/www\.gravatar\.com\/avatar.*/
    end
  end
end