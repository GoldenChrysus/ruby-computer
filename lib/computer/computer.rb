require "./lib/errors/require.rb"
require_relative "instruction.rb"

class Computer
	attr_reader :ptr, :addresses, :running

	# Create a new computer simulator
	# @param [Integer] num_addresses
	# @return [Computer]
	def initialize(num_addresses)
		raise Errors::Computer::InvalidAddressCount unless self.is_integer(num_addresses) and num_addresses >= 0

		@stack     = [] # Stack of input arguments
		@addresses = [nil] * num_addresses # Pre-allocate all addresses
		@ptr       = 0
		@running   = false
	end

	# Changes pointer to the provided address
	# @param [Integer] addr
	# @return [Computer]
	def set_address(addr)
		raise Errors::Computer::InvalidAddress unless self.is_integer(addr)
		raise Errors::Computer::AddressOutOfBounds unless addr >= 0 and addr <= self.limit

		@ptr = addr

		return self
	end

	# Write a comment to the current address pointer
	# @param [Array] *args
	# @return [Computer]
	def insert(*args)
		raise Errors::Computer::AddressOutOfBounds unless @ptr <= self.limit

		@addresses[@ptr] = Instruction.new(self, *args[0], *args[1, *args.length - 1])

		@ptr += 1

		return self
	end

	# Execute entire command list starting from current address pointer
	# @return [Computer]
	def execute
		@running = true

		# An instruction may terminate the program before the pointer reaches the end of the address list,
		# so we check that the program is both running and hasn't exhausted all addresses
		while @running and @ptr <= self.limit
			instruction = @addresses[@ptr]
			@ptr       += 1

			# The instruction is possibly `nil` from the pre-allocation in the initializer
			next unless instruction.is_a? Instruction

			instruction.process()
		end

		return self
	end

	# Set the running state of the computer
	# @param [Boolean] val
	# @return [Computer]
	def set_running(val)
		raise Errors::Computer::InvalidRunningState unless [true, false].include? val

		@running = val

		return self
	end

	# Pop arguments from the value stack
	# @param [Integer] n
	# @return [Array]
	def pop(n = 1)
		raise Errors::Computer::StackExceeded unless @stack.length >= n

		res = []

		for i in 0..n - 1
			res << @stack.pop()
		end

		return res
	end

	# Push argument onto the value stack
	# @param [Mixed] val
	# @return [Computer]
	def push(val)
		@stack.push(val)
		return self
	end

	private
		# Get address pointer limit
		# @return [Integer]
		def limit
			return @addresses.length - 1
		end

		# Helper function to determine if a value is an integer
		# @param [Mixed] val
		# @return [Boolean]
		def is_integer(val)
			return val.is_a? Integer
		end
end