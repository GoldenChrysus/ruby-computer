require "./lib/computer/computer.rb"
require "./lib/errors/require.rb"

describe Computer do
	describe ".initializer" do
		context "given a valid integer" do
			it "initializes an address array with length of provided integer" do
				comp = Computer.new(3)

				expect(comp.addresses.length).to eq(3)
			end
		end

		context "given a non-integer value" do
			it "raises an exception" do
				expect { comp = Computer.new("3") }.to raise_error(Errors::Computer::InvalidAddressCount)
			end
		end
	end

	describe ".addresses" do
		before(:each) do
			@computer = Computer.new(2)
		end

		context "given a valid address" do
			it "sets the pointer to that address" do
				expect(@computer.set_address(1).ptr).to eq(1)
			end
		end

		context "given an out-of-bounds address" do
			it "raises an exception" do
				expect { @computer.set_address(3) }.to raise_error(Errors::Computer::AddressOutOfBounds)
			end
		end

		context "given a non-integer address" do
			it "raises an exception" do
				expect { @computer.set_address("3") }.to raise_error(Errors::Computer::InvalidAddress)
			end
		end
	end

	describe ".state" do
		before(:all) do
			@computer = Computer.new(1)
		end

		context "given a valid Boolean value" do
			it "sets the running state to the provided value" do
				@computer.set_running(false)

				expect(@computer.running).to eq(false)

				@computer.set_running(true)

				expect(@computer.running).to eq(true)
			end
		end

		context "given a non-Boolean value" do
			it "raises an exception" do
				expect { @computer.set_running("false") }.to raise_error(Errors::Computer::InvalidRunningState)
			end
		end
	end

	describe ".instructions" do
		before(:each) do
			@output = StringIO.new
			
			$stdout = @output
		end

		context "given valid inputs" do
			it "PRINT outputs the correct value" do
				comp = Computer.new(3)

				comp.insert("PUSH", 5)
				comp.insert("PRINT")
				comp.insert("STOP")
				comp.set_address(0).execute()

				expect(@output.string).to eq("5\n")
			end

			it "MULT outputs the correct product" do
				comp = Computer.new(5)

				comp.insert("PUSH", 5)
				comp.insert("PUSH", 6)
				comp.insert("MULT")
				comp.insert("PRINT")
				comp.insert("STOP")
				comp.set_address(0).execute()

				expect(@output.string).to eq("30\n")
			end

			it "STOP prevents the program from continuing" do
				comp = Computer.new(10)

				comp.insert("STOP")
				comp.set_address(0).execute()

				expect(comp.ptr).to eq(1)
			end

			it "CALL moves the pointer to the correct address" do
				comp = Computer.new(10)

				comp.insert("CALL", 5)
				comp.set_address(5).insert("STOP")
				comp.set_address(0).execute()

				# Running the STOP instruction at address 5 increments the pointer,
				# so we should stop at address 6
				expect(comp.ptr).to eq(6)
			end

			it "RET sets the pointer to the correct address" do
				comp = Computer.new(30)

				comp.insert("PUSH", 20)
				comp.insert("RET")
				comp.set_address(0).execute()

				expect(comp.ptr).to eq(30)
			end
		end

		context "given invalid inputs" do
			it "PRINT raises an exception" do
				comp = Computer.new(1)

				comp.insert("PRINT")
				
				expect { comp.set_address(0).execute() }.to raise_error(Errors::Computer::StackExceeded)
			end

			it "MULT raises an exception if the stack is empty" do
				comp = Computer.new(1)

				comp.insert("MULT")
				
				expect { comp.set_address(0).execute() }.to raise_error(Errors::Computer::StackExceeded)
			end

			it "MULT raises an exception if the value is invalid" do
				comp = Computer.new(3)

				comp.insert("PUSH", 5)
				comp.insert("PUSH", "5")
				comp.insert("MULT")
				
				expect { comp.set_address(0).execute() }.to raise_error(Errors::Computer::Instruction::InvalidArgumentType)
			end

			it "CALL raises an exception if the argument is missing" do
				comp = Computer.new(1)

				expect { comp.insert("CALL") }.to raise_error(Errors::Computer::Instruction::InsufficientArguments)
			end

			it "PUSH raises an exception if the argument is missing" do
				comp = Computer.new(1)

				expect { comp.insert("PUSH") }.to raise_error(Errors::Computer::Instruction::InsufficientArguments)
			end

			it "RET raises an out-of-bounds exception for addresses exceeeding limit" do
				comp = Computer.new(2)

				comp.insert("PUSH", 20)
				comp.insert("RET")
				
				expect { comp.set_address(0).execute() }.to raise_error(Errors::Computer::AddressOutOfBounds)
			end

			it "RET raises an exception for non-integer addresses" do
				comp = Computer.new(2)

				comp.insert("PUSH", "20")
				comp.insert("RET")
				
				expect { comp.set_address(0).execute() }.to raise_error(Errors::Computer::InvalidAddress)
			end

			it "raises an exception when the instruction doesn't exist" do
				comp = Computer.new(1)

				expect { comp.insert("RETT") }.to raise_error(Errors::Computer::Instruction::InvalidInstruction)
			end

			it "raises an exception when the instruction is not provided" do
				comp = Computer.new(1)

				expect { comp.insert() }.to raise_error(ArgumentError)
			end

			it "raises an exception when the instruction is null" do
				comp = Computer.new(1)

				expect { comp.insert(nil) }.to raise_error(ArgumentError)
			end

			it "raises an exception when the instruction is not a string" do
				comp = Computer.new(1)

				expect { comp.insert(2) }.to raise_error(Errors::Computer::Instruction::InvalidInstruction)
			end

			it "raises an exception when the computer is invalid" do
				expect { Instruction.new("", "STOP") }.to raise_error(Errors::Computer::Instruction::InvalidComputer)
			end
		end
	end

	describe ".programs" do
		before(:each) do
			@output = StringIO.new
			
			$stdout = @output
		end

		it "executes the sample program" do
			comp = Computer.new(100)

			comp.set_address(50).insert("MULT").insert("PRINT").insert("RET")
			comp.set_address(0).insert("PUSH", 1009).insert("PRINT")
			comp.insert("PUSH", 6)
			comp.insert("PUSH", 101).insert("PUSH", 10).insert("CALL", 50)
			comp.insert("STOP")
			comp.set_address(0).execute()

			expect(@output.string).to eq("1009\n1010\n")
		end

		it "raises an exception when too many inserts occur" do
			comp = Computer.new(2)

			comp.insert("CALL", 0)
			comp.insert("CALL", 0)
		
			expect { comp.insert("CALL", 0) }.to raise_error(Errors::Computer::AddressOutOfBounds)
		end
	end
end