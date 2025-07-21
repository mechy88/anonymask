# spec/support/shared_contexts/admin_authenticated.rb
RSpec.shared_context "admin authenticated", shared_context: :metadata do
  let(:admin) { create(:user, username: "adminuser", email: "admin@example.com", role: :admin) }

  before do
    allow(Current).to receive(:user).and_return(admin)
  end
end
