require 'rails_helper'

feature 'Signing in', %q{
	In order to be able ask questions
	As a user
	I want to be able to sign in
    } do

	given!(:user) {FactoryGirl.create(:user)}
	scenario 'Existing user tries to sign in' do
	  #User.create(email: 'user@test.com, password: '12345678')
	
	  visit new_user_session_path
	  fill_in 'Email', with: 'user@test.com'
	  fill_in 'password', with: '12345678'
	  save_and_open_page
	  click_on 'Log in'

	  expect(page).to have_content 'Signed in successfully'
	  expect(page).to have_link 'Log out' 
	end
	scenario 'Non-Existing user tries to sign in' do
	  fill_in 'Email', with: 'wrong@test.com'
	  fill_in 'password', with: 'wrong'
	  save_and_open_screenshot
	  click_on 'Log in'

	  expect(page).to have_content 'Signed not successfully'
	  expect(page).to_not have_link 'Sign out'
	end
    end
