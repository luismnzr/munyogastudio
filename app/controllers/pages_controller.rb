class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:home, :calendario]

  def home
  end
end