require 'spec_helper'

describe User do

  before {@user = User.new(name: 'John Forton', email: 'john@forton.com',
                           password: 'foobar', password_confirmation: 'foobar')}
  subject {@user}

  it {should respond_to(:name)}
  it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:remember_token)}
  it {should respond_to(:admin)}
  it {should respond_to(:authenticate)}
  it {should respond_to(:microposts)}

  it {should be_valid}
  it {should_not be_admin}

  describe 'inaccessible attributes' do
    it 'should not allow assignment to the admin attribute' do
      expect do
        User.new(admin: true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'micropost associations' do
    let(:name) do
      Micropost.find_by_id(m.id).should be_nil
    end

    before {@user.save}
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it 'should have microposts in the correct order' do
      @user.microposts.by_date.should == [newer_micropost, older_micropost]
    end

    it 'should destroy associated microposts' do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |m|
        Micropost.find_by_id(m.id).should be nil
      end
    end
  end

  describe 'with admin attribute set to true' do
    before {@user.toggle!(:admin)}

    it {should be_admin}
  end

  describe 'return value of authenticate method' do
    before {@user.save}
    let(:found_user) {User.find_by_email(@user.email)}

    describe 'with valid password' do
      it {should == found_user.authenticate(@user.password)}
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) {found_user.authenticate('invalid')}
      it {should_not == user_for_invalid_password}
      specify {user_for_invalid_password.should be_false}
    end
  end

  describe 'when password is not present' do
    before {@user.password = @user.password_confirmation = ''}
    it {should_not be_valid}
  end

  describe 'with a password that is too short' do
    before {@user.password = @user.password_confirmation = 'a' * 5}
    it {should_not be_valid}
  end

  describe 'when password does not match confirmation' do
    before {@user.password_confirmation = 'mismtach'}
    it {should_not be_valid}
  end

  describe 'when the password confirmation is nil' do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end

  describe 'when name is not present' do
    before {@user.name = ''}
    it {should_not be_valid}
  end

  describe 'when email is not present' do
    before {@user.email = ''}
    it {should_not be_valid}
  end

  describe 'when name is too long' do
    before {@user.name = 'a' * 51}
    it {should_not be_valid}
  end

  describe 'when email format is invalid' do

    it 'should be invalid' do
      addresses = %w[joe@joe joe joe@joe,com joe@joe.]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe 'when email format is valid' do

    it 'should be valid' do
      addresses = %w[joe@joe.com jimmy@outlook.com jim_james@outlook.com jim.james@outlook.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe 'when email address is already taken' do

    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it {should_not be_valid}
  end

  describe 'email address with mixed case' do
    let(:mixed_case_email) {'Foo@ExaMple.COM'}

    it 'should be saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      @user.email.should == mixed_case_email.downcase
    end

  end

  describe 'remember token' do
    before {@user.save}
    its(:remember_token) {should_not be_blank}
  end

end
