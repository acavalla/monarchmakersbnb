feature 'Sign up' do
  scenario 'A user can sign up' do
    visit('/')
    click_button("Sign up")
    expect(current_path).to eq('/users/new')

    fill_in('email_new', with: "test@test.com")
    fill_in('password_new', with: "password123")
    fill_in('name', with: "John Smith")
    fill_in('username', with: "jsmith1")

    click_button('Submit')

    expect(current_path).to eq('/listings')
    expect(page).to have_content('Hi John Smith')

    expect(page).not_to have_button("Log in")
    expect(page).not_to have_button("Sign up")
    expect(page).to have_button("Log out")
    expect(page).to have_button("Add Listing")
  end

  scenario 'sign up with a username that has already been taken' do
    User.create(name: "name", email: "test@test.com", username: "username", password: "password123" )
    visit('/users/new')
    fill_in('email_new', with: "test1@test.com")
    fill_in('password_new', with: "password123")
    fill_in('name', with: "John Smith")
    fill_in('username', with: "username")

    click_button('Submit')
    expect(current_path).to eq('/users/new')
    expect(page).to have_content('This username has already been taken')
  end

  scenario 'sign up with a email that has already been taken' do
    User.create(name: "name", email: "test@test.com", username: "username", password: "password123" )
    visit('/users/new')
    fill_in('email_new', with: "test@test.com")
    fill_in('password_new', with: "password123")
    fill_in('name', with: "John Smith")
    fill_in('username', with: "name")

    click_button('Submit')
    expect(current_path).to eq('/users/new')
    expect(page).to have_content('This email address has already been taken')
  end


  scenario 'sign up with no password' do
    Capybara.current_driver = :selenium_headless
    visit('/users/new')

    fill_in('email_new', with: "test@test.com")
    # fill_in('password', with: "")
    fill_in('name', with: "John Smith")
    fill_in('username', with: "jsmith1")
    click_button('Submit')
    message = page.find('#password').native.attribute("validationMessage")
    messages = ["Please fill in this field.", "Please fill out this field."]
    expect(messages).to include message
  end
end
