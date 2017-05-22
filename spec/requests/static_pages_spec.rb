require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    before { visit root_path }
    subject { page }

    it { should have_selector('h1', text: 'Welcome to the Sample App')}
    it { should have_selector('title', :text => "Ruby on Rails Sample App | Home") }

  end

  describe "Contact page" do

    before { visit contact_path }
    subject { page }

    it { should have_selector('h1', text: 'Contact') }
    it { should have_selector('title', text: 'Ruby on Rails Sample App | Contact') }

  end

end
