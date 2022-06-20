require "./lib/errors/require.rb"

class Instruction
	# Map of allowed instructions and the number of arguments expected for the instruction
	@@TYPES = {
		MULT: 0,
		CALL: 1,
		RET: 0,
		STOP: 0,
		PRINT: 0,
		PUSH: 1
	}

	# Create a new instruction for the computer
	# @param [Computer] computer
	# @param [String] type
	# @param [Array] args
	# @return [Instruction]
	def initialize(computer, type, args = [])
		raise Errors::Computer::Instruction::InvalidComputer unless computer.is_a? Computer
		raise Errors::Computer::Instruction::InvalidInstruction unless type.is_a? String and type.length > 0

		@type = type.to_sym

		# A sliced single argument may have become a scalar value, so change it back to an array
		if not args.kind_of?(Array)
			args = [args]
		end

		raise Errors::Computer::Instruction::InvalidInstruction unless @@TYPES.key?(@type)
		raise Errors::Computer::Instruction::InsufficientArguments unless args.length >= @@TYPES[@type]

		@computer = computer
		@args     = args
	end

	# Processes the instruction
	def process
		case @type
		when :MULT
			product = 1
			vals    = @computer.pop(2)

			# Need to verify that each value is actually a number, so loop the list of values
			for x in vals
				raise Errors::Computer::Instruction::InvalidArgumentType unless x.is_a? Numeric

				product *= x
			end

			@computer.push(product)
		when :CALL
			@computer.set_address(@args[0])
		when :RET
			@computer.set_address(@computer.pop()[0])
		when :STOP
			@computer.set_running(false)
		when :PRINT
			puts @computer.pop()[0]
		when :PUSH
			@computer.push(@args[0])
		else
			# This should never occur since it's handled in the initializer, but it's here as a sanity check
			raise Errors::Computer::Instruction::InvalidInstruction
		end
	end
end