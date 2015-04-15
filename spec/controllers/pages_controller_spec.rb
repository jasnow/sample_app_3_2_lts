require 'spec_helper'

describe PagesController, :type => :controller do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do

    describe "when not signed in" do
      before(:each) do
        get :home
      end

      it "should be successful" do
        expect(response).to be_success
      end

      it "should have the right title" do
        expect(response).to have_selector("title",
          :content => "#{@base_title}Home")
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        other_user = FactoryGirl.create(:user,
          :email => FactoryGirl.generate(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following contents" do
        get :home
        expect(response).to have_selector("a",
          :href => following_user_path(@user),
          :content => "0 following")
        expect(response).to have_selector("a",
          :href => followers_user_path(@user),
          :content => "1 follower")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      expect(response).to be_success
    end

    it "should have the right title" do
      get 'contact'
      expect(response).to have_selector("title",
        :content => @base_title + "Contact")
    end

  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      expect(response).to be_success
    end

    it "should have the right title" do
      get 'about'
      expect(response).to have_selector("title",
        :content => @base_title + "About")
    end

  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      expect(response).to be_success
    end

    it "should have the right title" do
      get 'help'
      expect(response).to have_selector("title",
        :content => @base_title + "Help")
    end
  end

end
