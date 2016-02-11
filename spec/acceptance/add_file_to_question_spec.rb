require 'rails_helper'

feature 'Create answerdd files to question', %q{
	I want to be able to attach file while I create question
	As an authenticated user
    } do

    	given!(:user) { create(:user) }

    	scenario 'Authenticated user attaches file while creates question' do
    	  login(user)
		  visit questions_path
		  click_on 'Ask question'
		  fill_in 'Title', with: 'Test question'
		  fill_in 'Text', with: 'text text'
		  attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
		  click_on 'Create'
		  # save_and_open_page
		  # expect(page).to have_content 'Your question successfully created'
		  # expect(page).to have_content 'Test question'
		  # expect(page).to have_content 'text text'
    	end

    end