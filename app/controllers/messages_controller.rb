class MessagesController < ApplicationController
  def new
    @user = User.find_by(id: params[:id])
    @message = @user.received_messages.new
  end

  def index
    if params[:unread]
      @messages = Message.where({receiver_id: session[:user_id], is_read: false})
    elsif params[:sent]
      @messages = Message.where({sender_id: session[:user_id]})
    else
      @messages = Message.where({receiver_id: session[:user_id]})
    end
  end

  def show
  end

  def create
    Message.create({
      sender_id: session[:user_id],
      receiver_id: params[:id],
      body: params[:message][:body]
    })
    redirect_to '/messages'
  end

  def mark_read
    Message.update(params[:id], is_read: true)
    redirect_to '/messages'
  end
end
