require './spec/spec_helper'

describe Rsack::Server do 
	def server
		Rack::MockRequest.new(Rsack::Server.new)
	end

	# Página inicial
	context '/' do 

		it "Debería devolver el codigo 200" do 
			response = server.get('/')
			response.status.should == 200
		end

		it "Debería mostrar RPS GAME como título de la página" do 
			response = server.get('/')
			response.header == 'RPS GAME'
		end
	end
end