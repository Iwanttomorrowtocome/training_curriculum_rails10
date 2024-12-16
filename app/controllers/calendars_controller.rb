class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Rails.logger.debug params.inspect # デバッグ用
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to action: :index, notice: 'Plan was successfully created.'
    else
      Rails.logger.debug @plan.errors.full_messages.inspect # エラーメッセージを出力
      redirect_to action: :index, alert: 'Failed to save plan.'
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week

    @todays_date = Date.today
    @week_days = []
  
    plans = Plan.where(date: @todays_date..@todays_date + 6)
  
    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans }
　　　　 main
      @week_days.push(days)
    end
  end
end
