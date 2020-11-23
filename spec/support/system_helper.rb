module SystemHelper
 def login
  user = create(:user)
  visit '/login'
  fill_in 'email', with: user.email
  fill_in 'password', with: '12345678'
  click_button 'login' 
 end

 def login_as_user(user)
  visit login_path
  fill_in 'email', with: user.email
  fill_in 'password', with: '12345678'
  click_button 'login' 
 end
end
