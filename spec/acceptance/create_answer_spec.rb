require 'rails_helper'

feature 'Create answer', %q{
	I want to be able to create answer
	As an authenticated user
    } do

    	#background do
    	  # analogues to before
    	#end
    	given!(:user) { create(:user) }
    	given!(:question) { create(:question) }

    	scenario 'Authenticated user creates answer', js: true do
    	  login(user)
		  visit question_path(question)
		  fill_in 'Your Answer:', with: 'Test text of the answer'
		  click_on 'Create answer'
		  # save_and_open_page
		  # expect(page).to have_content 'New answer has been successfully created'
		  within '.answers' do
		  	expect(page).to have_content 'Test text of the answer'
		  end
    	end

    	scenario 'Non-authenticated user tries to create answer' do
    		visit question_path(question)
    		fill_in 'Your Answer:', with: 'Test text of the answer'
		  	click_on 'Create answer'
		    # save_and_open_page
		  	expect(page).to have_content 'You need to sign in or sign up before continuing.'
		  	expect(current_path).to eq new_user_session_path
    	end

    	scenario 'Authenticated user tries to create invalid answer' do
    	  login(user)
		  visit question_path(question)
		  click_on 'Create answer'
		  # save_and_open_page
		  expect(page).to have_content "Body can't be blank"
		  expect(page).to_not have_content "Test text of the answer"
    	end
  end