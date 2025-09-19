module PermissionModule
  extend ActiveSupport::Concern

  def authorize_role(roles)
    return if current_user.role == "super_admin"
    unless roles.include?(current_user.role)
      render json: { error: "Forbidden" }, status: :forbidden 
    end
  end

  def authorize_owner_or_manager(artist)
    return if current_user.role == "super_admin"
    unless owner?(artist) || manager?(artist)
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def owner?(resource)
    return true if current_user.super_admin
    resource.user == current_user
  end 

  def manager?(artist)
    return true if current_user.role == "super_admin"
    artist.manager == current_user 
  end
end
