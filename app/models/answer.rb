class Answer < ActiveRecord::Base
	
	belongs_to :question, touch: true
	belongs_to :user
	has_many :attachments, as: :attachable, dependent: :destroy

	validates :body, :question_id, presence: true

	accepts_nested_attributes_for :attachments

	def set_best
		# self.class.transaction do
		# ActiveRecord::Base.transaction do
		Answer.transaction do
			question.answers.update_all(best: false)
			update!(best: true)
		end
	end

end
