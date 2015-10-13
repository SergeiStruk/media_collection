require 'rails_helper'

feature 'Media Items' do
  scenario 'should be accessible only for logged in users' do
    visit '/media_items'
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

  def log_in
    user = create(:user)
    visit root_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_on 'Log in'
    user
  end
end
