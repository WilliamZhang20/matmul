import matplotlib.pyplot as plt
import csv
# opted to pythonize since it's just a text file!
x = []
y = []

# Read the data from the file
with open('benchmark_matmul.txt', 'r') as file:
    reader = csv.reader(file)
    for row in reader:
        x.append(float(row[0]))  # Assuming first column is x-axis
        y.append(float(row[2]))  # Assuming third column is y-axis

# Plotting the data
plt.plot(x, y, label='matmul.c', linewidth=2)
plt.title('Median GFLOPS')
plt.xlabel('m=n=k')
plt.ylabel('GFLOPS')
plt.legend()
plt.grid(True)
plt.show()