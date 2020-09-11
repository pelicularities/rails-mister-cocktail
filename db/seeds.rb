# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

Dose.destroy_all
Cocktail.destroy_all
Ingredient.destroy_all

ingredients_url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients_data = JSON.parse(open(ingredients_url).read)

puts 'seeding ingredients...'

ingredients_data['drinks'].each do |ingredient_hash|
  Ingredient.create!(name: ingredient_hash["strIngredient1"])
end

puts "#{Ingredient.count} ingredients seeded!"

puts 'seeding cocktails...'

('a'..'z').to_a.each do |letter|
  cocktails_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
  cocktails_data = JSON.parse(open(cocktails_url).read)

  cocktails_data["drinks"].each do |cocktail|
    name = cocktail['strDrink']
    photo = URI.open(cocktail['strDrinkThumb'])
    new_cocktail = Cocktail.new(name: name)
    new_cocktail.photo.attach(io: photo, filename: "#{name}.jpg", content_type: 'image/jpg')
    next unless new_cocktail.save
    puts "#{name} seeded!"

    # seed doses
    puts "seeding doses for #{name}..."
    num = 1
    until cocktail["strMeasure#{num}"].nil?
      # safety check, since there is no strMeasure16
      break if num == 16
      puts "seeding ingredient #{num}..."
      ingredient = Ingredient.all.sample
      description = cocktail["strMeasure#{num}"]

      # because it is possible for Ingredient.all.sample to choose an already sampled ingredient,
      # Dose.create is not guaranteed to work except for the first ingredient for any given cocktail
      # if it fails, no big deal, just keep going
      Dose.create(description: description, ingredient: ingredient, cocktail: new_cocktail)
      num += 1
    end
  end
end

puts 'completed seeding!'
