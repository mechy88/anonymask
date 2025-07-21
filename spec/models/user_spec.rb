require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    subject { build(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_presence_of(:role) }
  end

  describe "Associations" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:reactions) }
  end
end
