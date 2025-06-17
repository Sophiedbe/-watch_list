# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'net/http'
require 'json'

# Configuration de l'API TMDB
TMDB_API_KEY = ENV['80d07f540880a52408b0f49471da0efa'] # Vous devrez ajouter votre clé API dans les variables d'environnement
TMDB_BASE_URL = 'https://api.themoviedb.org/3'

def fetch_movies(page = 1)
  uri = URI("#{TMDB_BASE_URL}/movie/popular?api_key=80d07f540880a52408b0f49471da0efa&page=#{page}")
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)['results']
end

# Suppression des films existants
Movie.destroy_all

# Récupération et création des films
puts "Récupération des films depuis TMDB..."
movies = fetch_movies(1) # On récupère la première page de films populaires

movies.each do |movie_data|
  Movie.create!(
    title: movie_data['title'],
    overview: movie_data['overview'],
    poster_url: movie_data['poster_path']
  )
end

puts "Seed terminé ! #{Movie.count} films ont été créés."
