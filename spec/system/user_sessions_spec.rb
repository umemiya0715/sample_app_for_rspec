require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
 let(:user) { create(:user) }

 describe 'ログイン前' do
  context 'フォームの入力値が正常' do
   it 'ログイン処理が成功する' do
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_button 'Login'
    expect(current_path).to eq '/'
    expect(page).to have_content('Login successful'),
     'フラッシュメッセージ「Login successful」が表示されていません'
   end
 end
    
  context 'フォームが未入力' do
   it 'ログイン処理が失敗する' do
    visit '/login'
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_button 'Login'
    expect(current_path).to eq '/'
    expect(page).to have_content('Login failed'),
     'フラッシュメッセージ「Login failed」が表示されていません'
   end
  end
 end
 
 describe 'ログイン後' do
  before do
   login
  end
 
  context 'ログアウトボタンをクリック' do
   it 'ログアウト処理が成功する' do
    visit '/'
    click_on('Logout')
    expect(current_path).to eq '/'
    expect(page).to have_content('Logged out')
　　　'フラッシュメッセージ「Logged out」が表示されていません'
   end
  end
 end
end
