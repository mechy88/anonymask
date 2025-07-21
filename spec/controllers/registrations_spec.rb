require 'rails_helper'

RSpec.describe "RegistrationsController", type: :request do
  describe "GET /registration" do
    before do
      get new_registration_path
    end
    it "returns success status for signup form" do
      expect(response).to have_http_status(200)
    end

    it "returns the signup form" do
      expect(response).to render_template("registrations/new")
    end
  end

    describe "POST /registration" do
      it "redirects to posts upon successful signup" do
        params = {
          user: {
            email: "test@gmail.com",
            password: "securepassword",
            password_confirmation: "securepassword",
            username: "test",
            role: "user"
          }
        }

        post registration_path, params: params
        expect(response).to redirect_to posts_path
      end

      it "redirects to a new registration when signup is unsuccessful" do
        params = {
          user: {
            email: "test@gmail.com",
            password: "securepassword",
            password_confirmation: "securepassword",
            username: "test_test_test_test_test", # voilates validation by having a username over 20 characters
            role: "user"
          }
        }

        post registration_path, params: params
        expect(response).to render_template("registrations/new")
      end
    end
end
