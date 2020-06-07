class RoomsController < ApplicationController
  def show
  	@room = Room.find(params[:id])
    # present?の戻り値はboolean, よってtrueの場合、
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @direct_messages = @room.direct_messages
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @room   = Room.create(:name => "DM")
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user.id, :room_id).merge
    redirect_to room_path(@room_id) 
  end
  end
end
