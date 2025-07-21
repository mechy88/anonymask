# spec/support/shared_contexts/controller_shared_context.rb
RSpec.shared_context "controller setup", shared_context: :metadata do
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:user).and_return(user)
  end
end

RSpec.configure do |rspec|
  rspec.include_context "controller setup", type: :controller
end
