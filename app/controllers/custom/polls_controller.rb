require_dependency Rails.root.join("app", "controllers", "polls_controller").to_s

class PollsController < ApplicationController
  def show
    @questions = @poll.questions.for_render.sort_for_list
    @token = poll_voter_token(@poll, current_user)
    @poll_questions_answers = Poll::Question::Answer.where(question: @poll.questions)
                                                    .with_content.order(:given_order)

    @answers_by_question_id = {}
    poll_answers = ::Poll::Answer.by_question(@poll.question_ids).by_author(current_user&.id)
    poll_answers.each do |answer|
      if answer.question.is_single_choice?
        @answers_by_question_id[answer.question_id] = answer.answer_id
      else
        @answers_by_question_id[answer.question_id] = answer.open_answer
      end
    end

    @commentable = @poll
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
  end
end
