module EmojiHelper
  def emojify(content)
    emoji = Emoji.find_by_alias(content)
    emoji ? emoji.raw : content
  end
end
