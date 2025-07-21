require 'rails_helper'
require 'support/shared_contexts/admin_authenticated'

RSpec.describe UsersController, type: :controller do
  include_context "admin authenticated"

  let(:deletable_user) { create(:user, username: "todelete", email: "to_delete@example.com") }

  describe "GET #index" do
    it "assigns all users to @users" do
      get :index
      expect(assigns(:users)).to include(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    context "when user is found" do
      it "assigns the user to @user" do
        get :show, params: { id: admin.id }
        expect(assigns(:user)).to eq(admin)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is not found" do
      it "redirects to users_path with alert" do
        get :show, params: { id: 99999 }
        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to eq("User not found.")
      end
    end
  end

  describe "GET #new" do
    it "initializes a new user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_params) do
        {
          username: "sampleuser",
          email: "sample@example.com",
          password: "pass1234",
          password_confirmation: "pass1234",
          role: "user"
        }
      end

      it "creates a new user and redirects" do
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq("User was successfully created.")
      end
    end

    context "with invalid attributes" do
      let(:invalid_params) do
        {
          username: "",
          email: "",
          password: "",
          password_confirmation: "",
          role: ""
        }
      end

      it "does not create user and renders new" do
        expect {
          post :create, params: { user: invalid_params }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(assigns(:user).errors).not_to be_empty
      end
    end
  end

  describe "GET #edit" do
    it "assigns user and renders edit" do
      get :edit, params: { id: admin.id }
      expect(assigns(:user)).to eq(admin)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates user and redirects" do
        patch :update, params: { id: admin.id, user: { username: "updatedname" } }
        expect(admin.reload.username).to eq("updatedname")
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq("User was successfully updated.")
      end
    end

    context "with invalid attributes" do
      it "does not update and renders edit" do
        patch :update, params: { id: admin.id, user: { username: "" } }
        expect(assigns(:user).errors[:username]).not_to be_empty
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:to_delete) { create(:user, username: "deleteme", email: "delete@example.com") }

    it "deletes the user and redirects" do
      expect {
        delete :destroy, params: { id: to_delete.id }
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq("User was successfully deleted.")
    end
  end

  # ✅ Updated Admin Action Tests
  describe "PATCH #update_role" do
    let!(:normal_user) { create(:user, username: "user1", email: "user1@example.com", role: :user) }
    let!(:another_admin) { create(:user, username: "admin2", email: "admin2@example.com", role: :admin) }

    it "promotes a normal user to admin" do
      patch :update_role, params: { id: normal_user.id }
      expect(normal_user.reload.role).to eq("admin")
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq("#{normal_user.username} promoted to admin.")
    end

    it "demotes another admin to user" do
      patch :update_role, params: { id: another_admin.id }
      expect(another_admin.reload.role).to eq("user")
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq("#{another_admin.username} demoted to user.")
    end

    it "does not allow self role change" do
      patch :update_role, params: { id: admin.id }
      expect(admin.reload.role).to eq("admin")
      expect(response).to redirect_to(users_path)
      expect(flash[:alert]).to eq("You cannot change your own role.")
    end
  end
end
