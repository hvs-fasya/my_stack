require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question){ create(:question) }
  let(:user){ create(:user) }
  describe "GET #index" do
    before {get :index}
    # it "returns http success" do
    it 'loads all questions' do
      questions = create_list(:question, 3)
      # expect(response).to have_http_status(:success)
      expect(assigns(:questions)).to eq questions
    end
    it "renders #index template" do
      expect(response).to render_template :index
    end

  end

  describe "GET #show" do
    
    before {get :show, id: question}
    it 'loads question' do
      # expect(response).to have_http_status(:success)
      expect(assigns(:question)).to eq question
    end
    it "renders #show template" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    before do
      login(user)
      get :new
    end
    it "assigns new Question" do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it "renders #new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    let!(:question) { create(:question, user: user) }
    before do
      login(user)
      get :edit, id: question
    end
    it "loads question" do
      expect(assigns(:question)).to eq question
    end
    it "renders #edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    before do
      login(user)
    end
    context 'with valid' do
      it 'saves new question in DB' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirects to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid' do
      it 'does not save new question in DB' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'renders #new template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    let!(:question) { create(:question, user: user) }
    context 'with valid' do
     before do 
      login(user)
      patch :update, id: question, question: {title: 'new title', body: 'new body'}
     end
      it 'changes question' do
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to #show' do
        expect(response).to redirect_to question
      end
    end
    context 'with invalid' do
      before do 
        login(user)
        patch :update, id: question, question: {title: nil, body: nil}
      end
      it 'does not change question attributes' do
        old_title = question.title
        old_body = question.body
        question.reload
        expect(question.title).to eq old_title #"My question"
        expect(question.body).to eq old_body #"question body"
      end
      it 'renders #edit template' do
        expect(response).to render_template :edit
      end
    end
    context "NON-Author tries to update question" do
      let!(:other_user){ create(:user) }
      before do 
        login(other_user)
        patch :update, id: question, question: {title: 'new title', body: 'new body'}
      end
      it 'does not change question attributes' do
        old_title = question.title
        old_body = question.body
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end
    end
    context "Guest tries to update question" do
      before { patch :update, id: question, question: {title: 'new title', body: 'new body'} }
      it 'does not change question attributes' do
        old_title = question.title
        old_body = question.body
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq old_body
      end
    end
  end

  describe "DELETE #destroy" do
    before { login(user) }
    context "author deletes his own question" do
      let!(:question){ create(:question, user: user) }
      it 'deletes question from DB' do
        expect {delete :destroy, id: question}.to change(Question, :count).by(-1)
      end
      it 'redirects to #index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
    context "NonAuthor can not delete question" do
      before{ question }
      it 'does not delete question from DB' do
        expect {delete :destroy, id: question}.to_not change(Question, :count)
      end
    end
  end

end
