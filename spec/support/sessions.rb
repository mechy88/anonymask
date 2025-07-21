RSpec.shared_context :session do
  let(:user) { create(:user) }

  before do
      allow(Current).to receive(:user) { user }
  end
end
