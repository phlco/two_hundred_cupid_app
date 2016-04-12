class User < ActiveRecord::Base

  has_secure_password

  has_many :sent_messages,     class_name: "Message", foreign_key: :sender_id
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id

  # Paperclip
  has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def message(to, message)
    self.sent_messages.create({receiver: to, body: message})
  end

  def unread_messages
    self.received_messages.where(is_read: false)
  end
end
