require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  xit 'should be able to list all the albums' do
    response = get('/albums')

    expect(response.status).to eq 200
    
    expect(response.body).to include("<a href-'/albums/1'>Album 1 page</a>")
  end

  xit 'should be able to add an album and then list the modified list' do
    response = post("/albums", title: "Voyage", release_year: 2022, artist_id: 2)

    expect(response.status).to eq 200

    response2 = get('/albums')

    expect(response2.status).to eq 200
    expect(response2.body).to eq "Surfer Rosa 1988 1\nWaterloo 1974 2\nSuper Trouper 1980 2\nBossanova 1990 1\nLover 2019 3\nFolklore 2020 3\nI Put a Spell on You 1965 4\nBaltimore 1978 4\nHere Comes the Sun 1971 4\nFodder on My Wings 1982 4\nRing Ring 1973 2\nVoyage 2022 2"
  end

  xit "should be able to list all the artists" do
    response = get("/artists")

    expect(response.status).to eq 200
    expect(response.body).to include("<a href-'/artists/1'>Artist 1 page</a>")
  end

  xit "should be able to add an artist and it shows up when all are listed" do
    response = post("/artists", name: "Wild nothing", genre: 'Indie')

    expect(response.status).to eq 200

    response2 = get('/artists')

    expect(response2.status).to eq 200
    expect(response2.body).to eq "Pixies Rock\nABBA Pop\nTaylor Swift Pop\nNina Simone Pop\nKiasmos Experimental\nWild nothing Indie"
  end

  context "forms albums" do
    it "should create a form fill in page" do
      response = get("/albums/new")

      expect(response.status).to eq 200
      expect(response.body).to include('<form action="/albums/album_add" method="POST">')
    end

    it "should have a response page when the form is submitted" do
      response = post('/albums/album_add', title: "Album", release_year: 2022, artist_id: 1)

      expect(response.status).to eq 200
      expect(response.body).to include("Album added!")

      response2 = get('/albums')
      expect(response2.body).to include("Title: Album")
      expect(response2.body).to include("Release Year: 2022")
    end
  end

  context "forms artists" do
    it "should create a form fill in page" do
      response = get("/artists/new")

      expect(response.status).to eq 200
      expect(response.body).to include('<form action="/artists/artist_add" method="POST">')
    end

    it "should have a response page when submitted" do
      response = post('/artists/artist_add', name: "Artist", genre: "Indie")

      expect(response.status).to eq 200
      expect(response.body).to include("Artist added!")

      response2 = get('/artists')
      expect(response2.body).to include("Name: Artist")
      expect(response2.body).to include("Genre: Indie")
    end
  end

  context "get albums/:id" do
    it "should display album 2" do
      response = get('/albums/2')

      expect(response.status).to eq 200
      expect(response.body).to include("Artist: Pixies")
    end

    it "should display album 4" do
      response = get('/albums/4')

      expect(response.status).to eq 200
      expect(response.body).to include("Release year: 1980")
    end
  end
end
