require 'spec_helper'

describe "login page" do
 before(:all) do
  @user = FactoryGirl.create(:user, :name => "John", :email => "qwerty@example.com",:password => "secret",:password_confirmation => "secret")
 end

 after(:all) do
    @user.destroy
 end

 after(:each) do
   logout_user_page 
 end

 it "successful login with one account" do
    visit "/login"
    fill_in "Email", :with => "qwerty@example.com"
    fill_in "Password", :with => "secret"
    click_button "Log in"

    expect(page).to have_selector(".title", :text => "Meetings")
  end
end