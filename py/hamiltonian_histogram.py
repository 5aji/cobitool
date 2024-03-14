#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import sys

# Parse args
if len(sys.argv) != 3:
    exit(1)

graph_filename = sys.argv[1]
scanout_filename = sys.argv[2]

# Read data from COBI txt files
graph = np.negative(np.flip(np.loadtxt(graph_filename, dtype=int), 0))
np.set_printoptions(threshold=sys.maxsize)
scanout = np.flip(np.transpose(np.loadtxt(scanout_filename, dtype=int, comments="node")), 1)

# Convert to spins samples
spins = np.zeros((len(scanout), 64), dtype=int)
for i, sample in enumerate(scanout):
    for j, spin in enumerate(np.split(sample, 63)):
        values, counts = np.unique(spin, return_counts=True)
        if len(counts) == 2 and counts[0] == 4 and counts[1] == 4:
            #spins[i][j] = np.random.choice([-1,1], 1)[0] #0 # Ties have no influence
            spins[i][j] = 0 # Ties have no influence
        elif values[np.argmax(counts)] == 1:
            spins[i][j] = 1
        elif values[np.argmax(counts)] == 0:
            spins[i][j] = -1

spins = np.roll(spins, 1, axis=1)
a = []
for s in np.transpose(spins):
    values, counts = np.unique(s, return_counts=True)
    a.append(values[np.argmax(counts)])
print(a)

rand_spins = np.random.choice([-1,1], 64*len(scanout)).reshape((len(scanout), 64))

import qubo_lib
software_spins = qubo_lib.get_software_spins(graph_filename)
print(software_spins[0])

def gen_hamiltonians(spins):
    hamiltonians = []
    for s in spins:
        hamiltonian = 0
        for (x, y), weight in np.ndenumerate(graph):
            if x != y and x >= 1 and y >= 1:
                hamiltonian += weight * s[x] * s[y]
        hamiltonians.append(hamiltonian)
    return hamiltonians

software_hamiltonians = gen_hamiltonians(software_spins)
chip_hamiltonians = gen_hamiltonians(spins)
rand_hamiltonians = gen_hamiltonians(rand_spins)

plt.xlabel("Hamiltonian Value")
plt.ylabel("Count")

plt.axvline(x = np.min(software_hamiltonians), color = "red", label="Software Spins")
plt.hist(chip_hamiltonians, bins=100, label="COBI Spins")
plt.hist(rand_hamiltonians, bins=100, alpha=0.5, label="Random Spins")

plt.legend(loc="upper right")

print(f"Software min: {np.min(software_hamiltonians)}")
print(f"Chip min: {np.min(chip_hamiltonians)}")
print(f"Random min: {np.min(rand_hamiltonians)}")

plt.show()
