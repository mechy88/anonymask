require 'rails_helper'
require_relative '../support/sessions'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    before { get posts_path }

    it "returns success status when retrieving all posts" do
      expect(response).to have_http_status(200)
    end

    it "renders the index view" do
      expect(response).to render_template("posts/index")
    end
  end

  describe "GET /posts/:id" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    before do
      post
      get post_path(post.id)
    end

    it "renders the post view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET /posts/new" do
    include_context :session

    it "returns new post form when user is logged in" do
      get new_post_path
      expect(response).to render_template("posts/new")
    end
  end

  describe "POST /posts" do
    include_context :session

    post_params = {
      post: {
        title: "Example Title",
        content: "Lorem ispium elakuma sumbale"
      }
    }

    it "creates and redirects to the new post" do
      post posts_path, params: post_params
      expect(response).to redirect_to post_path(Post.last)
    end
  end

  describe "GET /posts/:id/edit" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    before do
      user
      post
    end

    context "when user is authorized to edit the post" do
      before { allow(Current).to receive(:user).and_return(user) }

      it "returns edit post form when user is logged in" do
        get edit_post_path(post)
        expect(response).to render_template("posts/edit")
      end
    end

    context "when current user is not authorized to edit the post" do
      let(:user2) { create(:user, username: "kyle", email: "kyle@gmail.com") }

      before { allow(Current).to receive(:user).and_return(user2) }

      it "redirects to posts path when user is not authorized" do
        get edit_post_path(post)
        expect(response).to redirect_to posts_path
      end
    end

    context "when current user is an admin" do
      let(:admin) { create(:user, :admin) }

      before { allow(Current).to receive(:user).and_return(admin) }

      it "allows admin to access another user's post for editing" do
        get edit_post_path(post)
        expect(response).to render_template("posts/edit")
      end
    end
  end

  describe "PATCH /posts/:id" do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    post_params = {
      post: {
        title: "Updated Title",
        content: "Updated Content"
      }
    }

    context "when user is authorized to update the post" do
      before { allow(Current).to receive(:user).and_return(user) }

      it "updates the post and redirects" do
        patch post_path(post), params: post_params
        expect(response).to redirect_to post_path(post)
        expect(post.reload.title).to eq("Updated Title")
      end
    end

    context "when current user is not authorized" do
      let(:user2) { create(:user, username: "other", email: "other@example.com") }

      before { allow(Current).to receive(:user).and_return(user2) }

      it "redirects to posts path" do
        patch post_path(post), params: post_params
        expect(response).to redirect_to posts_path
      end
    end

    context "when current user is an admin" do
      let(:admin) { create(:user, :admin) }

      before { allow(Current).to receive(:user).and_return(admin) }

      it "allows admin to update any post" do
        patch post_path(post), params: post_params
        expect(response).to redirect_to post_path(post)
        expect(post.reload.title).to eq("Updated Title")
      end
    end
  end

  describe "DELETE /posts/:id" do
    let(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }

    context "when user is authorized to delete the post" do
      before { allow(Current).to receive(:user).and_return(user) }

      it "deletes and redirects to posts index" do
        expect {
          delete post_path(post)
        }.to change(Post, :count).by(-1)

        expect(response).to redirect_to posts_path
      end
    end

    context "when current user is not authorized" do
      let(:user2) { create(:user, username: "peach", email: "peach@example.com") }

      before { allow(Current).to receive(:user).and_return(user2) }

      it "does not delete and redirects to posts path" do
        expect {
          delete post_path(post)
        }.not_to change(Post, :count)

        expect(response).to redirect_to posts_path
      end
    end

    context "when current user is an admin" do
      let(:admin) { create(:user, :admin) }

      before { allow(Current).to receive(:user).and_return(admin) }

      it "allows admin to delete any post" do
        expect {
          delete post_path(post)
        }.to change(Post, :count).by(-1)

        expect(response).to redirect_to posts_path
      end
    end
  end

  describe "PATCH /posts/:id/mark_seen" do
    let(:admin) { create(:user, :admin) }
    let(:post) { create(:post, status: :unseen) }

    before { allow(Current).to receive(:user).and_return(admin) }

    it "marks the post as seen" do
      patch mark_seen_post_path(post)
      expect(response).to redirect_to post_path(post)
      expect(post.reload.status).to eq("seen")
    end
  end

  describe "PATCH /posts/:id/mark_resolved" do
    let(:admin) { create(:user, :admin) }
    let(:post) { create(:post, status: :seen) }

    before { allow(Current).to receive(:user).and_return(admin) }

    it "marks the post as resolved" do
      patch mark_resolved_post_path(post)
      expect(response).to redirect_to post_path(post)
      expect(post.reload.status).to eq("resolved")
    end
  end
end
