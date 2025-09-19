class UsersController < ApplicationController
  include PermissionModule

  before_action -> { authorize_role(%w[super_admin]) }

  def index
    @users = User.with_attached_profile_picture.all
    puts "Users: #{@users.length}"
    render json: @users.map { |user| 
      user.as_json(except: [ :password_digest ]).merge(
          profile_picture: user.profile_picture.attached? ? url_for(user.profile_picture) : nil
      )
    }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: {user: user.slice(:id, :first_name, :email, :last_name, :role), status: :created}
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_content
    end
  end

  def profile
    render json: current_user.as_json(except: [ :password_digest ]).merge(
      profile_picture: current_user.profile_picture.attached? ? url_for(current_user.profile_picture) : nil
    )
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :role,
      :phone,
      :gender,
      :address,
      :dob,
      :profile_picture,
      :password,
    )
  end
end
