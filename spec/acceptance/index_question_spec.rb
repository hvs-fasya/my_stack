require 'rails_helper'

feature 'Index Questions', %q{
	I want to be able to get the whole list of questions
	As a guest-user
    } do


    	scenario 'Any user get the whole list of questions' do
    	  questions = create_list(:question, 5)
		  visit questions_path
		  save_and_open_page
		  questions.each do |question|
		      expect(page).to have_css("a", text: question.title)
		  end
		end

		scenario 'Any user get the EMPTY list of questions' do
		  visit questions_path
		  save_and_open_page
		  expect(page).to have_content "There are no any questions yet"
		end
  end