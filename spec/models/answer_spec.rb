require 'rails_helper'

RSpec.describe Answer, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question_id) }
  it { should belong_to(:question) }

  describe '#set_best' do
  	let!(:question){ create(:question) }
  	let!(:other_answer){ create(:answer, question: question, best: true) }
  	let(:answer){ create(:answer, question: question, best: false) }

  	it 'sets best-flag to true' do
  		answer.set_best
  		expect(answer).to be_best
  	end
  	it 'change other answers best flag to false' do
  		answer.set_best
  		expect(other_answer.reload).to_not be_best
  	end

  end

end