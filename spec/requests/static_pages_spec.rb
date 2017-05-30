require 'spec_helper'

describe 'StaticPages' do

  subject {page}

  shared_examples_for 'all static pages' do
    it {should have_selector('h1', text: heading)}
    it {should have_selector('title', text: full_title(page_title))}
  end

  it 'should have the right links on the layout' do
    visit root_path
    click_link 'About'
    page.should have_selector('title', text: 'About')
    click_link 'Help'
    page.should have_selector('title', text: 'Help')
    click_link 'Contact'
    page.should have_selector('title', text: 'Contact')
    click_link 'Home'
    click_link 'Sign up now!'
    page.should have_selector('title', text: 'Sign up')
    click_link 'sample app'
    page.should have_selector('title', text: 'Sample App')
  end

  describe 'Home page' do

    before {visit root_path}

    let(:heading) {'Welcome to the Sample App'}
    let(:page_title) {'Home'}

    it_should_behave_like 'all static pages'

    describe 'for signed-in users' do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'Dolor sit amet')
        sign_in user
        visit root_path
      end

      it 'should render the users feed' do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it {should have_content(user.microposts.count)}
      it {should have_content("#{user.microposts.count} microposts")}
    end

  end

  describe 'Contact page' do

    before {visit contact_path}

    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}

  end

end
