# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
pet_1 = Pet.create(adoptable: true, age: 1, breed: "beagle", name: "Snoopy", shelter_id: shelter_1.id)
pet_2 = Pet.create(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
pet_3 = Pet.create(adoptable: true, age: 4, breed: "beagle", name: "Snoop Dogg", shelter_id: shelter_1.id)
application_1 = Application.create(applicant_name: "Charlie Brown", full_address: "123 Peanuts Rd, Lansing MI, 48864", description: "Charlie has been looking forward to picking out a friend", application_status: "In Progress")
ApplicationPet.create(pet: pet_1, application: application_1)
ApplicationPet.create(pet: pet_2, application: application_1)
ApplicationPet.create(pet: pet_3, application: application_1)
