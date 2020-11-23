require 'rails_helper'

RSpec.describe 'Users', type: :system do
 let(:user) { FactoryBot.create(:user) } 

 describe 'ログイン前' do
  describe 'ユーザー新規登録' do
   context 'フォームの入力値が正常' do
    it 'ユーザーの新規作成が成功する' do
     visit '/sign_up'
      expect {
       fill_in 'Email', with: 'first@example.com'
       fill_in 'Password', with: '12345678'
       fill_in 'Password confirmation', with: '12345678'
       click_button 'SignUp'
      }.to change { User.count }.by(1)
       expect(page).to have_content ('User was successfully created'),
        'フラッシュメッセージ「User was successfully created」が表示されてません'
    end
   end
 
   context 'メールアドレスが未入力' do
    it 'ユーザーの新規作成が失敗する' do
     visit '/sign_up'
      expect {
       fill_in 'Email', with; ''
       fill_in 'Password', with: '12345678'
       fill_in 'Password comfirmation', with: '12345678'
       click_button 'SignUp'
      }.to change { User.count }.by(0)
      expect(page).to have_content ("Email can't be blank"),
       "フラッシュメッセージ「Email can't be blank」が表示されてません"
    end
   end

   context '登録済のメールアドレスを使用' do
    it 'ユーザーの新規作成が失敗する' do 
     visit '/sign_up'
      expect {
       fill_in 'Email', with: 'first@example.com'
       fill_in 'Password', with: '12345678'
       fill_in 'Password confirmation', with: '12345678'
       click_button 'Sign_up'
      }.to change { User.count }.by(0)
      expect(page).to have_content ('Email has already been taken'),
       'フラッシュメッセージ「Email has already been taken」が表示されてません'
    end
   end
  end
 end

 describe 'マイページ' do
  context 'ログインしていない状態' do
   it 'マイページへのアクセスが失敗する' do
    visit '/users/new'
    expect(page).to have_content ('Login required'),
     'フラッシュメッセージ「Login required」が表示されてません'
   end    
  end
 end

 describe 'ログイン後' do
  before do
   login
  end

  describe 'ユーザー編集' do
   context 'フォームの入力値が正常' do
    it 'ユーザーの編集が成功する'
     visit user_path
     click_on 'Edit'
     expect(current_path).to eq(edit_user_path), 'プロフィール編集ページに遷移していません'
     fill_in 'Email', with: 'edit@example.com'
     fill_in 'Password', with: '23456789'
     fill_in 'Password confirmation', with: '23456789'
     click_button 'Update'
     expect(current_path).to eq(user_path), 'プロフィールページに遷移していません'
     expect(page).to have_content('User was successfully updated'), 
      'フラッシュメッセージ「User was  successfully updated」が表示されていません'
     expect(page).to have_content('edit@example.com'), '更新後のメールアドレスが表示されていません'
     expect(page).to have_content('23456789'), '更新後のパスワードが表示されていません'
    end
   end

   context 'メールアドレスが未入力' do
    it 'ユーザーの編集が失敗する' do
     visit user_path
     click_on 'Edit'
     expect(current_path).to eq(edit_user_path), 'プロフィール編集ページに遷移していません'
     fill_in 'Email', with: ''
     fill_in 'Password', with: '23456789'
     fill_in 'Password confirmation', with: '23456789'
     click_button 'Update'
     expect(currrent_path).to eq(edit_user_path), 'プロフィール編集ページに遷移していません'
     expect(page).to have_content("Email can't be blank"),
      "エラーメッセージ「Email can't be blank」が表示されていません"
    end
   end

   context '登録済のメールアドレスを使用' do
    it 'ユーザーの編集が失敗する' do
     visit user_path
     click_on 'Edit'
     expect(current_path).to eq(edit_user_path), 'プロフィール編集ページに遷移していません'
     fill_in 'Email', with: 'user_1@example.com'
     fill_in 'Password', with: '23456789'
     fill_in 'Password confirmation', with: '23456789'
     click_button 'Update'
     expect(current_path).to eq(edit_user_path), 'プロフィール編集ページに遷移していません'
     expect(page).to have_content('Email has already been taken'), 
      'エラーメッセージ「Email has already been taken」が表示されていません'
    end
   end

   context '他ユーザーの編集ページにアクセス' do
    it '編集ページへのアクセスが失敗する' do
     user
     visit "/users/2"
     expect(current_path).to eq(user_path), 'プロフィールページに遷移していません'
     expect(page).to have_content('Forbidden access'), 
      'エラーメッセージ「Forbidden access」が表示されていません'
    end
   end

  describe 'マイページ' do
   context 'タスクを作成' do
    it '新規作成したタスクが表示される' do
     visit new_task_path
     fill_in 'Title', with: 'Test Title'
　　 fill_in 'Content', with: 'Test Content'
     click_button 'Create Task'
     expect(current_path).to eq('/tasks'), 'タスク一覧画面に遷移してません'
     expect(page).to have_content('Task was successfully created'),
      'フラッシュメッセージ「Task was successfully created」が表示されてません'
     expect(page).to have_content('Test Title'),
      '作成したタスクのタイトルが表示されていません'
     expect(page).to have_content('Test Content'),
      '作成したタスクの本文が表示されていません' 
    end
   end
  end
end
end
