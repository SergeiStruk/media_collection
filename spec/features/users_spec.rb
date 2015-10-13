require 'rails_helper'

describe "Users" do
  let(:user) { create(:user, email: 'johm.smith@mail.com') }

  context 'sign up' do
    before do
      visit '/users/sign_up'
    end

    scenario "should register user with correct credentials" do
      fill_in 'Email', with: 'new@mail.com'
      fill_in 'Password', with: 'password', match: :prefer_exact
      fill_in 'Password confirmation', with: 'password'
      click_on 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario "should not register user with incorrect credentials" do
      click_on 'Sign up'
      expect(page).to have_content 'Please review the problems below:'

      within '.user_email' do
        expect(page).to have_content "can't be blank"
      end

      within '.user_password' do
        expect(page).to have_content "can't be blank"
        expect(page).to have_content "8 characters minimum"
      end

      fill_in 'Email', with: 'fake'
      click_on 'Sign up'

      within '.user_email' do
        expect(page).to have_content "is invalid"
      end
    end

    scenario 'should not register user with same email twice' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password', match: :prefer_exact
      fill_in 'Password confirmation', with: 'password'
      click_on 'Sign up'

      within '.user_email.field_with_errors' do
        expect(page).to have_content "has already been taken"
      end
    end
  end

  context 'sign in' do
    before do
      visit '/users/sign_in'
    end

    scenario "should log in registered user" do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario "should not log in unregistered user" do
      fill_in 'Email', with: 'unregistered@mail.com'
      fill_in 'Password', with: 'password'
      click_on 'Log in'
      expect(page).to have_content 'Invalid email or password.'
    end
  end
end
