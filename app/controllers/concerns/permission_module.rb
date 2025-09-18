module PermissionModule
  extend ActiveSupport::Concern

  def authorize_role(roles)
    return if current_user.role == "super_admin"
    unless roles.include?(current_user.role)
      render json: { error: "Forbidden" }, status: :forbidden 
    end
  end

  def is_owner(resource)
    return if current_user.role == "super_admin"
    unless resource.user == current_user
      render json: {error: "Forbidden" }, status: :forbidden
    end
  end 

  def is_manager(artist)
    return if current_user.role == "super_admin"
    unless artist.manager == current_user || artist.manager == current_user.id
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end