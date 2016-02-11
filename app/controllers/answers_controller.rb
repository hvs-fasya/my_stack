class AnswersController < ApplicationController
  
  before_action :authenticate_user!, except: :new
  before_action :set_answer, only: [:update, :destroy]
  before_action :set_question, only: [:create, :new]
  before_action :check_author, only: [:update, :destroy]

  # authorize_resource

  def new
  	@answer = Answer.new
  end

  def create
  	@answer = @question.answers.new(answer_params)
  	respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, notice: 'New answer has been successfully created' }
        format.js
        format.json do
            response = { answers_count: @question.answers.count, answer: @answer }
            PrivatePub.publish_to "/questions/#{@answer.question_id}/answers",
                                response: response
            render json: response
          end
    	else
        format.html do 
          flash[:alert] = @answer.errors.full_messages.join(' ')
          redirect_to :back 
        end
        format.js
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
    	end
    end
  end

  def update
    @question = @answer.question
    if @answer.update(answer_params)
      redirect_to @question, notice: "Answer has been successfully updated"
    else
      flash[:alert] = @answer.errors.full_messages.join(' ')
      redirect_to @question
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
  	params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def check_author
    unless current_user.author_of?(@answer)
      redirect_to @answer.question, alert: 'You are not authorized for this action'
    end
  end

end
