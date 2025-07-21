require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /session" do
    before do
      get new_session_path
    end

    it "returns success status for login form" do
      expect(response).to have_http_status(200)
    end

    it "returns the login form" do
      expect(response).to render_template("sessions/new")
    end
  end

  describe "POST /session" do
    # Register a new user before all login tests
    before(:example) do
      FactoryBot.create(:user, email: "test@example.com", password: "securepassword")
    end

    it "redirects user to posts when logged in successfully" do
      params = {
        user: {
          email: "test@example.com",
          password: "securepassword"
        }
      }

      post session_path, params: params
      expect(response).to redirect_to posts_path
    end

    it "renders the login page again when submitting incorrect credentials" do
      params = {
        user: {
          email: "test@example.com",
          password: "maysecurepassword"
        }
      }

      post session_path, params: params
      expect(response).to render_template("sessions/new")
    end
  end

  describe "DELETE /session" do
    it "redirects user to home page upon logout" do
      delete session_path
      expect(response).to redirect_to root_path
    end
  end
end
