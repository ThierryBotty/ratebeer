module RatingAverage
  extend ActiveSupport::Concern
  include ActionView::Helpers::NumberHelper

  def average_rating
    number_with_precision((ratings.average(:score) || 0), precision: 1)
  end
end
