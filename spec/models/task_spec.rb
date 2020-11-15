require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
   
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid  
    end  
 
    it 'is invalid without title' do
      task = build(:task, title: nil)
      expect(task).to be_invalid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task = build(:task, status: nil)
      expect(task).to be_invalid
      expect(task.errors[:status]).to include("can't be blank")
    end
 
    it 'is invalid with a duplicate title' do
      task = build(:task)
      new_task = build(:task, title: 'First Title')
      new_task.valid?
      expect(task.errors[:title]).to include("has already been taken")   
    end
 
    it 'is valid with another title' do
      task = build(:task)
      new_task = build(:task, title: 'Second Title')
      expect(new_task).to be_valid
    end
  end
end
