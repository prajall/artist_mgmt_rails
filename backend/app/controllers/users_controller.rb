class UsersController < ApplicationController
  include PermissionModule

  before_action -> { authorize_role(%w[super_admin]) }, except: %i[profile]
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User
              .page(params[:page])
              .per(params[:limit])

    render json: @users
  end

  def create
    user = User.new(user_params)
    user.verified = true
    user.profile_picture.attach(params[:profile_picture]) if user_params[:profile_picture].present?

    if user.save
      render json: {user: user.slice(:id, :first_name, :email, :last_name, :role)}, methods: [:profile_picture_url], status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_content
    end
  end

  def show
    render json: @user
  end

  def profile
    render json: current_user.as_json(except: [ :password_digest ]).merge(
      profile_picture: current_user.profile_picture.attached? ? url_for(current_user.profile_picture) : nil
    )
  end

  # PATCH/PUT /users/1
  def update
    if @user.role == "super_admin" && @user != current_user
      return render json: {error: "Cannot edit other Admins"}, status: :forbidden 
    end
    if @user.update(edit_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  # DELETE /users/1
  def destroy
    return render json: {error: "Cannot delete Super Admins"}, status: :forbidden if @user.role == "super_admin"
    @user.destroy!
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    puts "Show called -------------------------------"
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
   def edit_params
     params.permit(
       :first_name,
       :last_name,
       :phone,
       :gender,
       :address,
       :dob,
       :profile_picture
     )
   end
end
