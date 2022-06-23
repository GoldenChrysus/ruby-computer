# Ruby Computer

This Ruby repository implements a computer simulator that allows writing of instructions to addresses and executing instructions starting from a given address.

## Instructions

- `MULT` - Pop 2 arguments from the input stack, multiply them, and push the product onto the input stack
- `CALL addr` - Sets the address pointer of the program
- `RET` - Pop 1 argument from the input stack and set address pointer to this value
- `STOP` - Stop execution of the running program
- `PRINT` - Pop 1 argument from the input stack and output it to standard output
- `PUSH arg` - Push argument onto the input stack

## Usage

A new computer simulator can be initialized with `computer = Computer.new(N)` where `N` is the number of addresses the computer should allocate.

An instruction can be added at the current address pointer via `computer.insert(instr, arg1, arg2, ..., argN)` where `instr` is the instruction to write and `arg#` represents optional arguments that may be provided depending on the desired instruction.
- Note that inserting an instruction will increment the address pointer once the instruction has been inserted.
- Inserting an instruction at an address that already has an instruction will _overwrite_ the existing instruction.

The address pointer of the computer can be explicitly set via `computer.set_address(addr)` where `addr` is an address value between `0` and `N - 1`.

## Demo

A demo program is provided in `main.rb`. You can execute it by running `ruby main.rb` in your terminal from within the project's root directory.

## Testing

A test suite has been added in the `spec/` directory. To run tests, first install the necessary gems via `bundle install`. The test suite can then be run via `bundle exec rspec --format documentation`.