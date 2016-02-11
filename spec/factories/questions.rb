FactoryGirl.define do

  factory :question do
  	sequence(:title) { |n| "Question number #{n}" }
  	sequence(:body) { |n| "Text for the question number #{n}" }
  	user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

end
