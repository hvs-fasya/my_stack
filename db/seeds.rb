# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Question.create([{title: 'Question One', body: 'The first question'},
			{title: 'Question Two', body: 'The second question'}])
Answer.create([{body: 'The first answer for question 1', question_id: '1'},
			{body: 'The second answer for question 1', question_id: '1'},
			{body: 'The first answer for question 2', question_id: '2'},
			{body: 'The second answer for question 2', question_id: '2'}])