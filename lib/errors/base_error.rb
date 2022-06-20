module Errors
	class BaseError < Exception
		def initialize(msg)
			super(msg)
		end
	end
end