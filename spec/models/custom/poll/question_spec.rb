require "rails_helper"

RSpec.describe Poll::Question, type: :model do
  let(:poll_question) { build(:poll_question) }

  describe "#is_single_choice?" do
    it "returns false when question has no answers" do
      expect(poll_question.is_single_choice?).to eq(false)
    end

    it "returns true when question has one answer or more" do
      create(:poll_question_answer, question: poll_question)

      expect(poll_question.is_single_choice?).to eq(true)
    end
  end
end
