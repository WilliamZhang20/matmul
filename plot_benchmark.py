import matplotlib.pyplot as plt

# Function to read the data from a file
def read_data(file_name):
    x = []
    y = []
    with open(file_name, 'r') as f:
        for line in f:
            values = line.split()
            x.append(int(values[0]))  # x values (first column)
            y.append(int(values[1]))  # y values (second column)
    return x, y

# Read data from both files
x1, y1 = read_data('benchmark_matmul.txt')
x2, y2 = read_data('benchmark_tut.txt')

# Create the plot
plt.figure(figsize=(10, 6))
plt.plot(x1, y1, label='File Tutorial (Second Column)', color='blue', linestyle='-', marker='o')
plt.plot(x2, y2, label='File Current (Second Column)', color='red', linestyle='-', marker='x')

# Adding titles and labels
plt.title('Comparison of Second Columns from Files A and B')
plt.xlabel('X Axis')
plt.ylabel('Second Column Values')
plt.legend()

# Show the plot
plt.grid(True)
plt.show()