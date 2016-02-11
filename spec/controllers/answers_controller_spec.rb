require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:answer) { create(:answer) }
  let (:question) { create(:question)}
  let (:user) { create(:user)}

  describe "GET #new" do
    before do 
      get :new, question_id: question
      login(user)
    end
    it "assigns new Answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it "renders #new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before do 
      login(user)
      request.env["HTTP_REFERER"] = "/questions/#{question.id}"
    end
    context 'with valid attributes' do
      it 'saves association between new answer and question in DB' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      it 'redirects to #show(question)' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        # expect(response).to redirect_to question_path(assigns(:question))
        expect(response).to render_template :create
      end
    end
    context 'with invalid' do
      it 'does not save new answer in DB' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 'renders #show(question) template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        # expect(response).to redirect_to question_path(assigns(:question))
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
      let!(:answer){ create(:answer, question: question, user: user) }
      context "author updates his own answer with VALID data" do
        before do 
          login(user)
          patch :update, id: answer, answer: { body: 'Answers new body'}
        end
        it "changes answers attributes in DB" do
          answer.reload
          expect(answer.body).to eq 'Answers new body'
        end
        it 'redirects to #show(question)' do
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end
      context "author updates his own answer with not-VALID data" do
        before do 
          login(user)
          patch :update, id: answer, answer: { body: nil }
        end
          it "does not change answers attributes in DB" do
            old_body = answer.body
            answer.reload
            expect(answer.body).to eq old_body
          end
          it "redirects to #show(question)" do
            expect(response).to redirect_to question_path(assigns(:question))
          end
      end
      context "NonAuthor tries to update answer" do
        let!(:other_user){ create(:user) }
        before do 
          login(other_user)
          patch :update, id: answer, answer: { body: 'Answers new body'}
        end
        it "does not change answers attributes in DB" do
          old_body = answer.body
          answer.reload
          expect(answer.body).to eq old_body
        end
      end
      context "Guest tries to update answer" do
        before { patch :update, id: answer, answer: { body: 'Answers new body'} }
        it "does not change answers attributes in DB" do
          old_body = answer.body
          answer.reload
          expect(answer.body).to eq old_body
        end
      end
  end

  describe "DELETE #destroy" do
      let!(:answer){ create(:answer, question: question, user: user) }
    context "author deletes his own answer" do
      before { login(user) }
      it 'deletes answer from DB' do
        expect {delete :destroy, id: answer}.to change(Answer, :count).by(-1)
      end
      it 'redirects to #show(question)' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context "NonAuthor can not delete answer" do
        let!(:other_user){create(:user)} 
        before { login (other_user) }
      it 'does not delete answer from DB' do
        expect {delete :destroy, id: answer}.to_not change(Answer, :count)
      end
    end
  end

end
