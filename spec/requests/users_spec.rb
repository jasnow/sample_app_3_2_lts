require 'spec_helper'

describe "Users", :type => :request do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        expect do
          visit signup_path
          fill_in :name,          :with => ""
          fill_in :email,         :with => ""
          fill_in :password,      :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          expect(response).to render_template('users/new')
          expect(response).to have_selector("div#error_explanation")
        end.not_to change(User, :count)
      end

      it "should not sign a user in" do
        visit signin_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        expect(response).to have_selector("div.flash.error",
          :content => "Invalid")
      end

    end

    describe "success" do
      it "should make a new user" do
        expect do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          expect(response).to have_selector('div.flash.success',
            :content => "Welcome")
          expect(response).to render_template('users/show')
        end.to change(User, :count).by(1)
      end

      it "should sign a user in and out" do
        user = FactoryGirl.create(:user)
        visit signin_path
        fill_in :email,    :with => user.email
        fill_in :password, :with => user.password
        click_button
        expect(controller).to be_signed_in
        click_link "Sign out"
        expect(controller).not_to be_signed_in
      end
    end
  end
end
