class LessonsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @lessons = Lesson.all
  end

  def show
    return redirect_to lessons_path, warning: 'レッスンはPC専用です。' if request.from_smartphone?
    @lesson = Lesson.find_by!(url: params[:url])
    if @lesson.url.match?("vimmer-01")
      gon.vimuta_src_url = helpers.asset_path 'vimmer_01_vimuta.png'
      gon.block_src_url = helpers.asset_path 'vimmer_01_block.png'
      gon.goal_src_url = helpers.asset_path 'vimmer_01_goal.png'
      render @lesson.url.gsub('-', '_')
      return
    end
    @commands = @lesson.commands.sample(20)
    gon.commands = @commands
    logged_in? ? gon.user_login_flag = true : gon.user_login_flag = false
  end
end
