require 'rails_helper'

RSpec.describe "Applications show", type: :feature do
  describe "As a visitor" do
    describe "When I visit an application's show page" do
      it "I can see the applicant's application data" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_1, application: application_1)
        ApplicationPet.create(pet: pet_2, application: application_1)
        visit "/applications/#{application_1.id}"

        expect(page).to have_content("Charlie Brown")
        expect(page).to have_content("123 Peanuts Rd, Lansing MI, 48864")
        expect(page).to have_content("Charlie has been looking forward to picking out a friend")
        expect(page).to have_content("Snoopy")
        expect(page).to have_content("In Progress")
      end
    end

    describe "Searching for Pets for an Application" do
      it "can search for pets by name" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_2, application: application_1)
        visit "/applications/#{application_1.id}"
        
        expect(page).to_not have_content("Snoopy")
        expect(page).to have_content("Add a Pet to this Application")
        expect(page).to have_field(:name)
        fill_in(:name, with: "Snoopy")
        click_on("Submit")
        expect(current_path).to eq("/applications/#{application_1.id}") 
        expect(page).to have_content("Snoopy")
      end
    end

    describe "Add a Pet to an Application" do
      it "can add pet(s) to an application by clicking on the 'Adopt this Pet' button" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_2, application: application_1)
        visit "/applications/#{application_1.id}"

        fill_in(:name, with: "Snoopy")
        click_on("Submit")
        
        expect(page).to have_button("Adopt this Pet")
        click_on("Adopt this Pet")
        expect(current_path).to eq("/applications/#{application_1.id}") 
        within("div.pets-to-be-adopted") do
          expect(page).to have_link("Snoopy")
        end
      end
    end

    describe "Be able to add final details and submit an application" do
      it "Should have an button to 'submit' the application" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_2, application: application_1)
        ApplicationPet.create(pet: pet_1, application: application_1)
        visit "/applications/#{application_1.id}"

        within("div.submit-application") do
          expect(page).to have_button("Submit Application")
        end
      end

      it "Add a 'reason why the applicant would be a good pet owner' dialogue to application" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_2, application: application_1)
        ApplicationPet.create(pet: pet_1, application: application_1)
        visit "/applications/#{application_1.id}"

        within("div.submit-application") do
          expect(page).to have_field(:why)
        end
      end

      it "Can no longer add pets to the application and the application status changes to pending" do
        shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        pet_1 = Pet.create(adoptable: true, age: 1, breed: "sphynx", name: "Snoopy", shelter_id: shelter_1.id)
        pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
        ApplicationPet.create(pet: pet_2, application: application_1)
        ApplicationPet.create(pet: pet_1, application: application_1)
        visit "/applications/#{application_1.id}"

        fill_in(:why, with: "Because")
        click_on("Submit Application")
        expect(current_path).to eq("/applications/#{application_1.id}") 
        within("div.application-status") do
          expect(page).to have_content("Pending")
        end
        expect(page).to_not have_content("Add a Pet to this Application")
      end
    end
  end
end