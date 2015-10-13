require 'rails_helper'

feature 'Media Items' do
  scenario 'should be accessible only for logged in users' do
    visit '/media_items/new'
    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(page).to_not have_content('Media items')
  end

  scenario 'user should see only own media items' do
    user = log_in
    create(:media_item, name: 'Item1', user: user)
    create(:media_item, name: 'Item2')

    visit root_path
    expect(page).to have_content('Item1')
    expect(page).to_not have_content('Item2')
  end

  scenario 'managing own media items', js: true do
    log_in
    expect(page).to have_content('Media items:')

    expect(page).to_not have_content('Item1')
    click_on 'Add Item'
    fill_in 'Name', with: 'Item1'
    fill_in 'Url', with: 'http://example.com'
    select "Website", from: "Media Type"
    click_on 'Create Media item'
    expect(page).to have_content('Item1')
    expect(page).to have_content('Media items:')

    page.evaluate_script('window.confirm = function() { return true; }')
    within '#media_items' do
      click_on 'Delete'
    end
    expect(page).to_not have_content('Item1')
  end

  context 'should search by media item names as' do
    scenario 'registered user' do
      user = log_in
      create(:media_item, name: 'Item11', user: user)
      create(:media_item, name: 'Item12', is_private: false)
      create(:media_item, name: 'Item13')

      visit '/media_items'
      expect(page).to have_content('Item11')
      expect(page).to have_content('Item12')
      expect(page).not_to have_content('Item13')

      fill_in 'search', with: 'Item1'
      find_field('search').native.send_key(:enter)
      expect(page).to have_content('Item11')
      expect(page).to have_content('Item12')
      expect(page).not_to have_content('Item13')

      fill_in 'search', with: 'Item12'
      find_field('search').native.send_key(:enter)
      expect(page).to_not have_content('Item11')
      expect(page).to have_content('Item12')
      expect(page).not_to have_content('Item13')
    end

    scenario 'unregistered user' do
      create(:media_item, name: 'Item11', is_private: false)
      create(:media_item, name: 'Item12', is_private: false)
      create(:media_item, name: 'Item13')

      visit root_path

      expect(page).to have_content('Item11')
      expect(page).to have_content('Item12')
      expect(page).not_to have_content('Item13')

      fill_in 'search', with: 'Item11'
      find_field('search').native.send_key(:enter)
      expect(page).to have_content('Item11')
      expect(page).not_to have_content('Item12')
      expect(page).not_to have_content('Item13')
    end
  end

  def log_in
    user = create(:user)
    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_on 'Log in'
    user
  end
end
