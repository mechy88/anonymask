# spec/controllers/comments_controller_spec.rb
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  include_context "controller setup"

  describe "POST #create" do
    let(:post_record) { create(:post, user: user) }

    context "with valid attributes" do
      let(:valid_attributes) { { content: "This is a comment" } }

      it "creates a comment and redirects to the post" do
        expect {
          post :create, params: { post_id: post_record.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(post_path(post_record))
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { content: "" } }

      it "does not create a comment and renders the post show template" do
        expect {
          post :create, params: { post_id: post_record.id, comment: invalid_attributes }
        }.not_to change(Comment, :count)

        expect(response).to render_template("posts/show")
      end
    end
  end

  describe "PATCH #update" do
    let(:post_record) { create(:post, user: user) }
    let!(:comment) { create(:comment, user: user, post: post_record) }

    context "as the comment owner" do
      it "updates the comment and redirects to the comment show page" do
        patch :update, params: {
          post_id: post_record.id,
          id: comment.id,
          comment: { content: "Updated comment" }
        }

        expect(comment.reload.content).to eq("Updated comment")
        expect(response).to redirect_to(post_comment_path(post_record, comment))
      end
    end
  end

  describe "DELETE #destroy" do
    let(:post_record) { create(:post, user: user) }
    let!(:comment) { create(:comment, user: user, post: post_record) }

    it "destroys the comment and redirects to the post" do
      expect {
        delete :destroy, params: { post_id: post_record.id, id: comment.id }
      }.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(post_path(post_record))
    end
  end

  describe "authorization" do
    let(:other_user) { create(:user, email: "other@example.com") }
    let(:post_record) { create(:post, user: other_user) }
    let!(:comment) { create(:comment, user: other_user, post: post_record) }

    it "does not allow updating another user's comment" do
      patch :update, params: {
        post_id: post_record.id,
        id: comment.id,
        comment: { content: "Hacked" }
      }

      expect(comment.reload.content).not_to eq("Hacked")
      expect(response).to redirect_to(post_path(post_record))
    end
  end
end
