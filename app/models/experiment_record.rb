class ExperimentRecord < ApplicationRecord
  validates :experimented_on, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  #実験日、実験名、開始時刻が同じものは登録できない
  validates :name, uniqueness: { scope: [:experimented_on, :start_at, :user_id] }
  validate :valid_Time_expression
  before_save :change_str_to_time

  belongs_to :user

  def calc_required_time
    s = Time.zone.parse(self.start_at)
    e = Time.zone.parse(self.end_at)

    if s.nil? or e.nil?
      return
    elsif s > e
      return
    else
      r = (e - s)/(60)
      self.required_time = r.divmod(60)[0].to_s + '時間' + r.divmod(60)[1].to_int.to_s + '分'
    end
  end

  def change_str_to_time
    self.experimented_on = Time.zone.parse(experimented_on).strftime("%Y-%m-%d")
    change_start_time
    change_end_time
    self
  end

  private

  def valid_Time_expression
    [:experimented_on, :start_at, :end_at].each do |time|
      if !self.send(time).blank?
        begin
          Time.zone.parse(self.send(time))
        rescue => exception
          errors.add(time, 'の入力が不適切です')
        end
      end
    end
    """
    if !experimented_on.blank?
      begin
        Time.zone.parse(experimented_on)
      rescue => exception
        errors.add(:experimented_on, 'の入力が不適切です')
      end
    end

    if !start_at.blank?
      begin
        Time.zone.parse(start_at)
      rescue => exception
        errors.add(:start_at, 'の入力が不適切です')
      end
    end

    if !end_at.blank?
      begin
        Time.zone.parse(end_at)
      rescue => exception
        errors.add(:end_at, 'の入力が不適切です')
      end
    end
    """
  end

  def change_start_time
    if !self.start_at.blank?
      if self.start_at.include?("/") or start_at.include?("-")
        self.start_at = Time.zone.parse(start_at)
      else
        self.start_at = Time.zone.parse(experimented_on + " " + start_at)
      end
    else
      self.start_at = self.experimented_on
    end
  end

  def change_end_time
    if !self.end_at.blank?
      if self.end_at.include?("/") or end_at.include?("-")
        self.end_at = Time.zone.parse(end_at)
      else
        self.end_at = Time.zone.parse(experimented_on + " " + end_at)
      end
    else
      self.end_at = Time.zone.now.strftime("%Y-%m-%d %H:%M")
    end
  end
end
