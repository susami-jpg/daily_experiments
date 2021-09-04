class ExperimentRecord < ApplicationRecord
  validates :experimented_on, presence: true, length: { maximum: 30 }
  validates :name, presence: true
  #実験日、実験名、開始時刻が同じものは登録できない
  validates :name, uniqueness: { scope: [:experimented_on, :start_at] }
  validate :valid_Time_expression
  before_save :change_str_to_time, :calc_required_time

  belongs_to :user

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

  def change_str_to_time
    self.experimented_on = Time.zone.parse(experimented_on).strftime("%Y-%m-%d")
    self.start_at = Time.zone.parse(experimented_on + " " + start_at)
    if !end_at.blank?
      self.end_at = Time.zone.parse(self.end_at)
    end
    self
  end

  def calc_required_time
    if start_at.blank? or end_at.blank?
      return true
    end
    s = self.start_at = Time.zone.parse(experimented_on + " " + start_at)
    e = self.end_at = Time.zone.parse(self.end_at)
    if s > e
      return true
    end
    r = (e - s)/(60)
    self.required_time = r.divmod(60)[0].to_s + '時間' + r.divmod(60)[1].to_int.to_s + '分'
  end
end
