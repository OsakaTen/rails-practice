class HomeController < ApplicationController
# index は誰でも見れる
  before_action :authenticate_user!

  def index
  end
end
