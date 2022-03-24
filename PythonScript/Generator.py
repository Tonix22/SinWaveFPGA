import math
import numpy as np
import matplotlib.pylab as plt
from sympy import Li, Line

x = np.linspace(0,np.pi/2, 256)
sine = .5*(np.sin(x)+1)
sine = sine*255
print (len(sine))

shaper = sine.reshape(64, 4)
# obtain svd
U, S, V = np.linalg.svd(shaper,full_matrices=False)
S = np.diag(S)

#principal componenet analysis
r = 1
low_rank = U[:, :r] @ S[0:r,:r] @ V[:r, :]

sine = low_rank.flatten()
sine = np.floor(sine).astype(int)-128
sine = np.clip(sine,0,127)

plt.plot(x,sine)
plt.xlabel('Angle [rad]')
plt.ylabel('sin(x)')
plt.axis('tight')
plt.show()

(uniq, freq) = (np.unique(sine, return_counts=True))
print(np.column_stack((uniq,freq)))
print(len(uniq))


file = open('output.txt', 'w')
for n in range (0,len(uniq)):
    print(uniq[n]<<4|freq[n], file=file)
file.close()

# RECONSTRUCT SIN
building = []

file = open('output.txt', 'r')
Lines = file.readlines()
file.close()
count = 0

#first stage
for n in Lines:
    val  = int(n)
    level   = val>>4
    huffman = val&15
    for m in range(0,huffman):
        building.append(level+127)


#second stage reverse acces
for n in reversed(Lines):
    val  = int(n)
    level   = val>>4
    huffman = val&15
    for m in range(0,huffman):
        building.append(level+127)


#third stage invert
for n in Lines:
    val  = int(n)
    level   = val>>4
    huffman = val&15
    for m in range(0,huffman):
        building.append((-1)*level+127)


#fourht stage the risen
for n in reversed(Lines):
    val  = int(n)
    level   = val>>4
    huffman = val&15
    for m in range(0,huffman):
        building.append((-1)*level+127)




x = np.linspace(0,2*np.pi, 256*4)
plt.plot(x,building)
plt.show()

"""
building = []
stage  = 0
offset = 127
for n in uniq:
    for m in range(0,n):
        building.append(uniq)
    offset=offset+1
        


"""