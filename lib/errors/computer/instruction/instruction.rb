require "./lib/errors/base_error.rb"

module Errors
	module Computer
		module Instruction
			class InvalidComputer < BaseError
				def initialize
					super("Invalid Computer provided.")
				end
			end

			class InvalidInstruction < BaseError
				def initialize
					super("Invalid instruction provided.")
				end
			end
		
			class InsufficientArguments < BaseError
				def initialize
					super("Insufficient arguments provided for this instruction.")
				end
			end

			class InvalidArgumentType < BaseError
				def initialize
					super("Invalid argument type provided.")
				end
			end
		end
	end
end