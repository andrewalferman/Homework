#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr  5 19:20:18 2017

@author: andrewalferman
"""

import os
import subprocess as sp
import re
import pylab as pyl
import numpy as np
import csv as csv

filename = 'Project_2_Alferman'


def Deleteoldcode(filename):
    """Delete the old compiled code if it exists."""
    try:
        os.remove(filename + '.out')
    except Exception:
        pass
    return None


def Runcommand(i, j, k, l):
    """A function for running all the C code and obtaining the output."""
    command = str(('g++-6 -DNUMT={} -DARRAYSIZE={}'.format(i, j) +
                   ' -DDYNAM={} -DCHUNKSIZE={} ').format(k, l) +
                  filename + '.cpp -o ' + filename + '.out -lm -fopenmp')
    os.system(command)
    command = './' + filename + '.out'
    output = str(sp.check_output(command, shell=True)).replace('\\n', '\n')
    output = output.replace("b'", "")
    return output


# Initialize lists for determining speedup later
megas = []

# Set up lists of all the parameters to run the code for
minpow = 7
threadslist = [i for i in range(1, 18) if (i % 2 == 0 or i == 1)]
arraysizes = [32 * 1024]
schedules = [0, 1]
chunksizes = [1, 4096]

headers = ['Threads', 'Array Size', 'Chunk Size', 'Schedule', 'MegaMults/sec']
data = np.array(headers)
print(headers)

# Run the code for all the parameters in several nested for loops
for i in threadslist:
    for j in arraysizes:
        for k in schedules:
            for l in chunksizes:
                Deleteoldcode(filename)
                output = Runcommand(i, j, k, l)
                numbers = re.findall(r'\d*\.\d+|\d+', output)
                print(numbers)
                data = np.vstack((data, numbers))
for i in data[1:]:
    if i[3] == '0':
        i[3] = 'static'
    else:
        i[3] = 'dynamic'
with open('Project_2_Data.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Analyze the data
static1 = np.array([i for i in data if (i[3] == 'static' and i[2] == '1')])
static4096 = np.array([i for i in data if (i[3] == 'static' and
                                           i[2] == '4096')])
dynamic1 = np.array([i for i in data if (i[3] == 'dynamic' and i[2] == '1')])
dynamic4096 = np.array([i for i in data if (i[3] == 'dynamic' and
                                            i[2] == '4096')])

# Plot the data
fs = 14
fig = pyl.figure(0, figsize=(10, 6))
x = fig.add_subplot(111)
pyl.title('Speed (MegaMults/second) vs. Number of Nodes', fontsize=fs+2)
pyl.xlabel('Number of Nodes', fontsize=fs)
pyl.xticks(threadslist)
pyl.ylabel('Speed (MegaMults/second)', fontsize=fs)
x.plot(static1[:, 0], static1[:, 4], label='static-1')
x.plot(static4096[:, 0], static4096[:, 4], label='static-4096')
x.plot(dynamic1[:, 0], dynamic1[:, 4], label='dynamic-1')
x.plot(dynamic4096[:, 0], dynamic4096[:, 4], label='dynamic-4096')
x.grid(which='both')
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)
pyl.savefig('speeds.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
pyl.show()
