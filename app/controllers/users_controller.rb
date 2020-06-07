class UsersController < ApplicationController
  before_action :authenticate_user!
	before_action :baria_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end

      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end


  def index
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end
  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(@user), notice: "successfully updated user!"
  	else

  		render :edit
  	end
  end
  # user.rbのhas_many :followings, through: :relationships, source: :follow
  def follows
    @users = current_user.followings
  end

  # user.rbの has_many :followers, through: :reverse_of_relationships, source: :user
  def follower
    @users = current_user.followers
  end
# user <%= form_for(@user) do |f| %>したときに３つのものしかもってこない(user_params)
  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。他の人ユーザーに見られないようにする   ＝＝違ったら  3行目
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end
