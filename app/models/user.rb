class User < ActiveRecord::Base

  has_secure_password

  has_many :sent_messages,     class_name: "Message", foreign_key: :sender_id
  has_many :received_messages, class_name: "Message", foreign_key: :receiver_id

  def message(to, message)
    self.sent_messages.create({receiver: to, body: message})
  end

  def unread_messages
    self.received_messages.where(is_read: false)
  end
end
