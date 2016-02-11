FactoryGirl.define do

  # factory :answer do
  #   body "answer body"
  # end
  factory :answer do
  	sequence(:body) { |n| "Answer number #{n}" }
  	question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end

end
