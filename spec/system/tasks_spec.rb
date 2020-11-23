require 'rails_helper'

RSpec.describe "Tasks", type: :system do
 let(:user) { create(:user) }
 let(:task) { create(:task, user: user) }

 describe 'ログインしている状態' do
  before do 
   login
  end

  context 'タスクの新規作成' do
   it '新規作成したタスクが表示される' do
    click_on('New task')
    fill_in 'Title', with: 'Test Title'
    fill_in 'Content', with: 'Test Content'
    click_button 'Create Task'
    expect(current_path).to eq('/tasks'), 'タスク一覧画面に遷移していません'
    expect(page).to have_content('Task was successfully created'),
     'フラッシュメッセージ「Task was successfully created」が表示されていません'
    expect(page).to have_content('Test Title'),
     '作成したタスクのタイトルが表示されていません'
    expect(page).to have_content('Test Content'),
     '作成したタスクの本文が表示されていません'
   end
  end
 
  content 'タスクの編集' do
   it '編集したタスクが表示される' do
    task
    visit '/tasks'
    click_on('Edit')
    fill_in 'Title', with: 'Edited Title'
    fill_in 'Content', with: 'Edited Content'
    click_button 'Update Task'
    expect(current_path).to eq task_path(task)
    expect(page).to have_content('Task was successfully updated'),
     'フラッシュメッセージ「Task was successfully updated」が表示されていません'
    expect(page).to have_content('Edited Title'),
     '更新後のタイトルが表示されていません'
    expect(page).to have_content('Edited Content'),
     '更新後の本文が表示されていません'
   end
  end

  context 'タスクの削除' do
   it 'タスクを削除できること' do
    visit '/tasks'
    click_on('Destroy')
    expect(current_path).to eq('/tasks'),
     'タスク削除後に、タスクの一覧ページに遷移していません'
    expect(page).to have_content('Task was successfully destroyed'),
     'フラッシュメッセージ「Task was successfully destroyed」が表示されていません' 
   end
  end

  context '他ユーザーの編集ページにアクセス' do
   it '編集ページへのアクセスが失敗する' do
    visit edit_task_path(task)
    expect(current_path).to eq('/')
    expect(page).to have_content('Forbidden access'),
     'エラーメッセージ「Forbidden access」が表示されていません'
   end
  end
 end
 
 describe 'ログイン前' do
  before do 
   task
  end

  context 'タスクの新規作成' do
   it '新規作成に失敗する' do
    visit new_task_path(task)
    expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
    expect(page).to have_content('Login required'),
     'エラーメッセージ「Login required」が表示されていません'
   end
  end
  
  context 'タスクの編集' do
   it '編集に失敗する' do
    visit edit_task_path(task)
    expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
    expect(page).to have_content('Login required'),
     'エラーメッセージ「Login required」が表示されていません'
   end
  end
 end
end
