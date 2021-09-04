class ExperimentRecord < ApplicationRecord
  validates :experimented_on, presence: true, length: { maximum: 30 }
  validates :name, presence: true
  #実験日、実験名、開始時刻が同じものは登録できない
  validates :name, uniqueness: { scope: [:experimented_on, :start_at] }
  validate :valid_Time_expression

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
end
