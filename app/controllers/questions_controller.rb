class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    # authorize! :index, Question
  	@questions = Question.all
  end

  def show
    # authorize! :show, @question
  end

  def new
    # authorize! :create, Question
    @question = Question.new
  end

  def edit
    # authorize! :update, @question
  end

  def create
    # authorize! :create, Question
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    # authorize! :update, @question
  	if @question.update(question_params)
  		redirect_to @question
  	else
  		render :edit
  	end
  end

  def destroy
    # authorize! :destroy, @question
  	@question.destroy #if current_user.author_of?(@question)
  	redirect_to questions_path
  end

  private

  def question_params
  	params.require(:question).permit(:title, :body,
      attachments_attributes: [:file])
  end

  def load_question
  	@question = Question.find(params[:id])
  end

end
