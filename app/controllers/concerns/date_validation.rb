module DateValidation
  extend ActiveSupport::Concern

  def valid_date?(str)
    Date.iso8601(str)
    true
  rescue ArgumentError
    false
  end

  def date_range_within_one_year?(start_date, end_date)
    (Date.iso8601(end_date) - Date.iso8601(start_date)).to_i <= 365
  rescue ArgumentError
    false
  end
end
