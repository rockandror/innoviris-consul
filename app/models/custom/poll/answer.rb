require_dependency Rails.root.join("app", "models", "poll", "answer").to_s

class Poll::Answer
  belongs_to :answer, class_name: "Poll::Question::Answer", inverse_of: :answers

  _validators.reject! { |field, _| field == :answer }

  _validate_callbacks.each do |callback|
    [ActiveModel::Validations::InclusionValidator,
      ActiveModel::Validations::PresenceValidator].each do |validator|
      if callback.raw_filter.is_a?(validator)
        callback.raw_filter.attributes.delete :answer
      end
    end
  end

  validates :answer, presence: true, if: ->(a) { a.question&.is_single_choice? }
  validates :answer, inclusion: { in: ->(a) { a.question.question_answers }},
                     if: ->(a) { a.question&.is_single_choice? }
  validates :open_answer, presence: true, if: ->(a) { !a.question&.is_single_choice? }
end
