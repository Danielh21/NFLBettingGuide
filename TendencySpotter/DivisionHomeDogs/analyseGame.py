import sys

# Check if the correct number of arguments has been provided
if len(sys.argv) != 2:
    print("Usage: python script_name.py <parameter>")
    sys.exit(1)  # Exit with an error code

# Access the parameter
parameter = sys.argv[1]

# Use the parameter
print(f"The parameter you entered is: {parameter}")


