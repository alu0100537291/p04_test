require 'rack/request'
require 'rack/response'
require 'haml'
require 'thin'
require 'rack'

p "Please visit http://localhost:8080"
  
module RockPaperScissors
  class App 

    def initialize(app = nil)
      @app = app
      @content_type = :html
      @defeat = {'rock' => 'scissors', 'paper' => 'rock', 'scissors' => 'paper'}
      @throws = @defeat.keys
    end

    def haml(template, resultado)
      template_file = File.open(template, 'r')
      Haml::Engine.new(File.read(template_file)).render({},resultado)
    end

    def set_env(env)
      @env = env
      @session = env['rack.session']
    end

    def won
      return @session['won'].to_i if @session['won']
      @session['won'] = 0
    end

    def won=(value)
      @session['won'] = value
    end

    def lost
      return @session['lost'].to_i if @session['lost']
      @session['lost'] = 0
    end

    def lost=(value)
      @session['lost'] = value
    end

    def tied
      return @session['tied'].to_i if @session['tied']
      @session['tied'] = 0
    end

    def tied=(value)
      @session['tied'] = value
    end
                    
    def play
      return @session['play'].to_i if @session['play']
      @session['play'] = 0
    end

    def play=(value)
      @session['play'] = value
    end

    def call(env)
      set_env(env)
      player_throw = ''
      anwser = ''
      req = Rack::Request.new(env)
      player_throw = req.GET["choice"]
      computer_throw = @throws.sample

      if !@throws.include?(player_throw)
        aux = "Choose one"
      else
        computer_throw = @throws.sample
        self.play= self.play + 1
      end

      anwser = 
              if (player_throw != nil && computer_throw != nil)
                if (player_throw == computer_throw)
                  "TIE"
                elsif computer_throw == @defeat[player_throw]
                  "WIN"
                else
                  "LOSE"
                end
              end
	
      if anwser == "WIN"
        self.won= self.won + 1
      elsif anwser == "LOSE"
        self.lost= self.lost + 1
      elsif anwser == "TIE"
        self.tied= self.tied + 1
      end

      # Hash con info
    	resultado = 
    		{
          :aux => aux,
          :anwser => anwser,
          :choose => @choose,
          :throws => @throws,
          :computer_throw => computer_throw,
          :player_throw => player_throw,
          :win => self.won,
          :lose => self.lost,
          :tie => self.tied,
          :play => self.play,
        }

        res = Rack::Response.new(haml("views/index.html.haml", resultado))
        res.finish     
    end # call
  end   # App
end     # RockPaperScissors