# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @result = repo.all
    
    return erb(:albumslist)
  end

  post '/albums' do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    repo.create(album)
  end

  get "/artists" do
    repo = ArtistRepository.new
    @result = repo.all
    
    return erb(:artistslist)
  end

  post "/artists" do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]

    repo.create(artist)
  end

  get "/artists/new" do
    return erb(:new_artist)
  end

  post "/artists/artist_add" do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]

    repo.create(artist)

    return erb(:artist_add)
  end

  get "/albums/new" do
    return erb(:new_album)
  end

  post "/albums/album_add" do
    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]

    repo.create(album)

    return erb(:album_add)
  end
  
  get "/albums/:id" do
  #get /\/albums\/:id/ do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])

    repo = ArtistRepository.new
    @artist = repo.find(@album.artist_id)

    return erb(:album)
  end

  get "/artists/:id" do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  get "/albums/:id/delete" do
    repo = AlbumRepository.new
    repo.delete(params[:id])

    return erb(:album_del)
  end
end