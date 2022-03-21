require_dependency Rails.root.join("app", "models", "poll", "partial_result").to_s

class Poll::PartialResult
  belongs_to :answer, class_name: "Poll::Question::Answer", inverse_of: :partial_results

  _validators.reject! { |field, _| field == :answer }

  _validate_callbacks.each do |callback|
    if callback.raw_filter.is_a?(ActiveModel::Validations::InclusionValidator)
      callback.raw_filter.attributes.delete :answer
    end
  end

  validates :answer, inclusion: { in: ->(a) { a.question.question_answers }},
                     unless: ->(a) { a.question.blank? }
end
