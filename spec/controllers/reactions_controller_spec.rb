require 'rails_helper'
require_relative '../support/sessions'
include EmojiHelper

RSpec.describe "Reactions", type: :request do
  include_context :session
  describe "POST /reactions" do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }

    before do
      user
      post_record
    end

    it "creates a reaction" do
      reaction_params = {
        reaction: {
          reaction: emojify("thumbsup")
        }
      }

      expect {
        post post_reactions_path(post_record.id), params: reaction_params
      }.to change(Reaction, :count).by(1)
    end

    context "when user has already reacted to a post" do
      it "does not create a new reaction" do
        reaction_params = {
          reaction: {
            reaction: emojify("thumbsup"),
            post_id: post_record.id
          }
        }
        post post_reactions_path(post_record.id), params: reaction_params
        expect {
          post post_reactions_path(post_record.id), params: reaction_params
        }.not_to change(Reaction, :count)
      end
    end
  end



  describe "PATCH /reactions/:id" do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }
    let(:reaction_record) { create(:reaction, user: user, post: post_record) }

    before do
      user
      post_record
      reaction_record
    end

    it "updates a reaction" do
      reaction_params = {
        reaction: {
          reaction: emojify("heart"),
          post_id: post_record.id
        }
      }

      patch post_reaction_path(post_record.id, reaction_record.id), params: reaction_params

      expect(Reaction.find(reaction_record.id).reaction).to eq(reaction_params[:reaction][:reaction])
    end
  end

  describe "DELETE /reactions/:id" do
    let(:user) { create(:user) }
    let(:post_record) { create(:post, user: user) }
    let(:reaction_record) { create(:reaction, user: user, post: post_record) }

    before do
      user
      post_record
      reaction_record
    end

    it "deletes a reaction" do
      delete post_reaction_path(post_record.id, reaction_record.id)

      expect(Reaction.find_by(id: reaction_record.id)).to eq(nil)
    end
  end
end
