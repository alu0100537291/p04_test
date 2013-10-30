require "test/unit"
require "rack/test"
require './lib/rock_paper.rb'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @nav = Rack::Test::Session.new(Rack::MockSession.new(Rack::Session::Cookie.new(RockPaperScissors::App.new, 
                 :key => 'rack.session', :domain => 'example.com', :secret => 'cookie')))
  end

  def app
    Rack::Builder.new do 
      run @nav
    end
  end

  def test_index
    @nav.get "/"
    assert @nav.last_response.ok? 
  end

  def test_titulo
    @nav.get "/"
    assert_match "<title>RPS GAME</title>", @nav.last_response.body
  end

  def test_ganador
    @nav.post "/?choice=scissors"
    computer_throw = 'paper'
    assert_match "WIN", @nav.last_response.body
  end

  def test_estadistica
    @nav.get "/"
    assert_match "<h4>Estadisticas</h4>", @nav.last_response.body
  end
end