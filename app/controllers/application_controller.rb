class ApplicationController < ActionController::Base
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  def record_not_found
    return render json: { error: 'Record does not exist' }, status: 404
  end
end
