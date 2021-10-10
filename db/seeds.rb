# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  name: 'admin',
  email: 'admin@example.com',
  password: 'tokyoportboal',
  password_confirmation: 'tokyoportboal',
  admin: true
  )

User.create!(
  name: 'testuser',
  email: 'test@example.com',
  password: 'testyyy345',
  password_confirmation: 'testyyy345',
  admin: true
  )

User.create!(
  name: 'sampleuser',
  email: 'sample@example.com',
  password: 'sampleyyy345',
  password_confirmation: 'sampleyyy345',
  admin: false
  )