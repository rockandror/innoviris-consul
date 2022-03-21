require_dependency Rails.root.join("app", "controllers", "polls", "questions_controller").to_s

class Polls::QuestionsController < ApplicationController
  def answer
    answer = @question.answers.find_or_initialize_by(author: current_user)
    token = params[:token]

    answer.answer = @question.question_answers.find(params[:answer_id])
    answer.save_and_record_voter_participation(token)

    @answers_by_question_id = { @question.id => answer.answer.id }
  end
end
