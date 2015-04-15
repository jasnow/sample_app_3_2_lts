require 'spec_helper'

describe UsersController, :type => :controller do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    # Exercise 11.5.4:
    it "should paginate microposts" do
      35.times { FactoryGirl.create(:micropost,
        :user => @user, :content => "foo") }
      FactoryGirl.create(:micropost, :user => @user,
        :content => "a" * 55)
      get :show, :id => @user
      expect(response).to have_selector('div.pagination')
    end

    it "should be successful" do
      get :show, :id => @user
      expect(response).to be_success
    end

    it "should have the right title" do
      get :show, :id => @user
      expect(assigns(:user)).to eq(@user)
    end

    it "should include the users name" do
      get :show, :id => @user
      expect(response).to have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      expect(response).to have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      expect(response).to be_success
    end

    it "should have the right title" do
      get 'new'
      expect(response).to have_selector("title", :content => "Sign up")
    end

    it "should have a name field" do
      get :new
      expect(response).to have_selector(
        "input[name='user[name]'][type='text']")
    end
    it "should have a email field" do
      get :new
      expect(response).to have_selector(
        "input[name='user[email]'][type='text']")
    end
    it "should have a password field" do
      get :new
      expect(response).to have_selector(
        "input[name='user[password]'][type='password']")
    end
    it "should have a password confirmation field" do
      get :new
      expect(response).to have_selector(
        "input[name='user[password_confirmation]'][type='password']")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
          :password_confirmation => "" }
      end

      it "should not create a user" do
        expect do
          post :create, :user => @attr
        end.not_to change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        expect(response).to have_selector("title", :content => "Sign up")
      end

      it "should render the 'new page'" do
        post :create, :user => @attr
        expect(response).to render_template('new')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
          :password => "foobar", :password_confirmation => "foobar" }
      end

     it "should create a user" do
        expect do
          post :create, :user => @attr
        end.to change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        expect(response).to redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        expect(flash[:success]).to match(/welcome to the sample app/i)
      end

      it "should sign the user in" do
        post :create, :user => @attr
        expect(controller).to be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
    end

    it "should have the right title" do
      get :edit, :id => @user
      expect(response).to have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      expect(response).to have_selector("a", :href => gravatar_url,
        :content => "change")
    end

  end # get/edit

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "",
                 :password => "", :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        expect(response).to render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        expect(response).to have_selector("title", :content => "Edit user")
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.org",
                :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        expect(@user.name).to  eq(@attr[:name])
        expect(@user.email).to eq(@attr[:email])
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        expect(response).to redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        expect(flash[:success]).to match(/updated/)
      end
    end
  end

  describe "authentication of edit/update pages" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        expect(response).to redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        get :update, :id => @user, :user => {}
        expect(response).to redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        expect(response).to redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        get :update, :id => @user, :user => {}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        expect(response).to redirect_to(signin_path)
        expect(flash[:notice]).to match(/sign in/i)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @second = FactoryGirl.create(:user, :email => "another@example.com")
        third  = FactoryGirl.create(:user, :email => "another@example.net")
        @users = [@user, @second, third]
        30.times do
          @users << FactoryGirl.create(:user,
            :email => FactoryGirl.generate(:email))
        end
      end

      it "should be successful" do
        get :index
        expect(response).to be_success
      end

      it "should have the right title" do
        get :index
        expect(response).to have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          expect(response).to have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        expect(response).to have_selector("div.pagination")
        expect(response).to have_selector("span.disabled",
          :content => "Previous")
        expect(response).to have_selector("a", :content => "2")
        #:href => "/users?page=2",
        expect(response).to have_selector("a", :content => "Next")
        # :href => "/users?page=2",
      end

      # Exercise 11.5..2:
      it "should display the micropost count" do
        10.times { FactoryGirl.create(:micropost, :user => @user,
          :content => "foo") }
        get :show, :id => @user
        expect(response).to have_selector('td.sidebar',
          :content => @user.microposts.count.to_s)
      end

      # Next two tests are for Chapter 10 (Exercise 4).
      it "should not see delete links if not admin" do
        get :index
        expect(response).not_to have_selector("a", :href => "/users/2",
          :content => "delete")
      end

      it "should show the user's microposts" do
        mp1 = FactoryGirl.create(:micropost, :user => @user,
          :content => "Foo bar")
        mp2 = FactoryGirl.create(:micropost, :user => @user,
          :content => "Baz guux")
        get :show, :id => @user
        expect(response).to have_selector("span.content",
          :content => mp1.content)
        expect(response).to have_selector("span.content",
          :content => mp2.content)
      end

      # Exercise 11.5.6:
      it "should not see micropost delete links of other people's microposts" do
        mp3 = FactoryGirl.create(:micropost, :user => @second,
          :content => "Foo bar")
        mp4 = FactoryGirl.create(:micropost, :user => @second,
          :content => "Baz guux")
        get :show, :id => @user
        expect(response).not_to have_selector("span.content",
          :content => mp3.content)
        expect(response).not_to have_selector("span.content",
          :content => mp4.content)

        get :show, :id => @second
        expect(response).to have_selector("span.content",
          :content => mp3.content)
        expect(response).to have_selector("span.content",
          :content => mp4.content)
      end
    end
  end

  describe "DELETE 'destory'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        expect(response).to redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        expect(response).to redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        @admin = FactoryGirl.create(:user, :email => "admin@example.com",
          :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        expect do
          delete :destroy, :id => @user
        end.to change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        expect(flash[:success]).to match(/destroyed/)
        expect(response).to redirect_to(users_path)
      end

      it "should not be able to destroy itself" do
        expect do
          delete :destroy, :id => @admin
        end.to change(User, :count).by(0)
      end
   end

  end # delete/destroy

  describe "follow pages" do
    describe "when not signed in" do
      it "should protect 'following'" do
        get :following, :id => 1
        expect(response).to redirect_to(signin_path)
      end

      it "should protect 'followers'" do
        get :followers, :id => 1
        expect(response).to redirect_to(signin_path)
      end
    end

    describe "when signed in" do
      before(:each) do
        @user = test_sign_in(FactoryGirl.create(:user))
        @other_user = FactoryGirl.create(:user,
          :email => FactoryGirl.generate(:email))
        @user.follow!(@other_user)
      end

      it "should show user following" do
        get :following, :id => @user
        expect(response).to have_selector("a", :href => user_path(@other_user),
                                           :content => @other_user.name)
      end

      it "should show user followers" do
        get :followers, :id => @other_user
        expect(response).to have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end
  end
end
