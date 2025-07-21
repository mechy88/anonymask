module PostsHelper
  def can_manage_post?(post)
    Current.user == post.user || Current.user&.admin?
  end

  def can_manage_comment?(comment)
    Current.user == comment.user || Current.user&.admin?
  end

  def status_button(post)
    return unless can_manage_post?(post)

    case post.status
    when "unseen"
      button_to "Mark as Seen", mark_seen_post_path(post), method: :patch, class: "bg-yellow-500 text-black px-4 py-1 rounded mb-2"
    when "seen"
      button_to "Mark as Resolved", mark_resolved_post_path(post), method: :patch, class: "bg-green-600 text-black px-4 py-1 rounded mb-2"
    end
  end
end
