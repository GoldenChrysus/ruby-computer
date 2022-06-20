require "./lib/errors/base_error.rb"

module Errors
	module Computer
		class InvalidAddressCount < BaseError
			def initialize
				super("Invalid address count provided.")
			end
		end

		class InvalidAddress < BaseError
			def initialize
				super("Invalid address provided.")
			end
		end

		class AddressOutOfBounds < BaseError
			def initialize
				super("Address out of bounds.")
			end
		end

		class StackExceeded < BaseError
			def initialize
				super("Program stack exceeded.")
			end
		end

		class InvalidRunningState < BaseError
			def initialize
				super("Invalid running state provided.")
			end
		end
	end
end