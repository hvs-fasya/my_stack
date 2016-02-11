require 'rails_helper'

feature 'Show Question', %q{
	I want to be able to get the Question with the list of Answers
	As a guest-user
    } do


	  given!(:user) { create(:user) }
	  given!(:questions) { create_list(:question, 1) }
	  given!(:answers) { create_list(:answer, 5, question: questions[0]) }

      scenario 'Guest-user get the Questions with the list of Answers' do
		  visit questions_path
		  # save_and_open_page
		  click_on questions[0].title
		  # save_and_open_page
		  expect(page).to have_content questions[0].title
		  expect(page).to have_content questions[0].body
		  answers.each do |answer|
		    expect(page).to have_content answer.body
		  end
		end

  end