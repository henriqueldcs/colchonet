class RoomsController < ApplicationController

  PER_PAGE = 1

  before_action :require_authentication, 
    only: [:new, :edit, :create, :update, :destroy]

  def index
    @search_query = params[:q]
    
    rooms = Room.search(@search_query).page(params[:page]).per(PER_PAGE)
    @rooms = RoomCollectionPresenter.new(rooms.order(id: :desc), self)
  end

  def show
    room_model = Room.friendly.find(params[:id])
    @room = RoomPresenter.new(room_model, self)
    
    #if user_signed_in? 
    #  @user_review = @room.reviews.find_or_initialize_by(user_id: current_user.id)
    #end
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
    @room = current_user.rooms.friendly.find(params[:id])
  end

  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to @room, notice: t('flash.notice.room_created')
    else
      render action: 'new'
    end
  end

  def update
    
    @room = current_user.rooms.friendly.find(params[:id])
    
    if @room.update(room_params)
      redirect_to @room, notice: t('flash.notice.room_updated') 
    else
      render action: 'edit'
    end
  end

  def destroy
    @room = current_user.rooms.friendly.find(params[:id])
    @room.destroy
      redirect_to rooms_url
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.
        require(:room).
        permit(:title, :location, :description)
    end
end
