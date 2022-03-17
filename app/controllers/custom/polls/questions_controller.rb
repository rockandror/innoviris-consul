require_dependency Rails.root.join("app", "controllers", "polls", "questions_controller").to_s

class Polls::QuestionsController < ApplicationController
  def answer
    answer = @question.answers.find_or_initialize_by(author: current_user)
    token = params[:token]

    if @question.is_single_choice?
      answer.answer = @question.question_answers.find(params[:answer_id])
    else
      answer.open_answer = params[:open_answer]
    end
    answer.save_and_record_voter_participation(token)

    @answers_by_question_id = { @question.id => answer.answer_id || answer.open_answer }
  end
end
