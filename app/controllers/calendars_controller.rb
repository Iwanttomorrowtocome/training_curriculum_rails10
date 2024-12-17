class CalendarsController < ApplicationController

  # 1週間のカレンダーと予定を表示
  def index
    get_week
    @plan = Plan.new # フォーム用のインスタンス
  end

  # 予定の保存
  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to action: :index, notice: '予定が保存されました。'
    else
      redirect_to action: :index, alert: '予定の保存に失敗しました。'
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']

    @todays_date = Date.today
    @week_days = []

    # 1週間分の予定を取得
    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      days = {
        month: (@todays_date + x).month,
        date: (@todays_date + x).day,
        wday: wdays[(@todays_date + x).wday],
        plans: today_plans
      }
      @week_days.push(days)
    end
  end
end
