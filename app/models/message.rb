class Message < ActiveRecord::Base
  belongs_to :receiver, class_name: "User"
  belongs_to :sender,   class_name: "User"

  def reply(message)
    m = self.class.new({body: message})
    m.sender = self.receiver
    m.receiver = self.sender
    m.save
  end

  def read?
    self.is_read
  end

end
