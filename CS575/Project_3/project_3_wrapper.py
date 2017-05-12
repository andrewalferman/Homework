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

filename = 'Project_3_Alferman'


def Deleteoldcode(filename):
    """Delete the old compiled code if it exists."""
    try:
        os.remove(filename + '.out')
    except Exception:
        pass
    return None


def Runcommand(i, j, k):
    """A function for running all the C code and obtaining the output."""
    command = str(('g++-6 -DNUMT={} -DNUMPAD={} -DFIX2={} '.format(i, j, k)) +
                  filename + '.cpp -o ' + filename + '.out -lm -fopenmp')
    os.system(command)
    command = './' + filename + '.out'
    output = str(sp.check_output(command, shell=True)).replace('\\n', '\n')
    output = output.replace("b'", "")
    return output


# Set up lists of all the parameters to run the code for
minpow = 7
threadslist = [i for i in range(1, 18) if (i % 2 == 0 or i == 1)]
numpads = range(32)
privatelist = [0, 1]

headers = ['Threads', 'NumPad', 'Fix 2', 'MegaAdds/sec']
data = np.array(headers)
print(headers)

# Run the code for all the parameters in several nested for loops
datalists = []
for k in privatelist:
    for i in threadslist:
        threadspeeds = []
        if k == 0:
            for j in numpads:
                Deleteoldcode(filename)
                output = Runcommand(i, j, k)
                numbers = re.findall(r'\d*\.\d+|\d+', output)
                print(numbers)
                data = np.vstack((data, numbers))
                threadspeeds.append(numbers)
        else:
            Deleteoldcode(filename)
            output = Runcommand(i, 0, k)
            numbers = re.findall(r'\d*\.\d+|\d+', output)
            print(numbers)
            data = np.vstack((data, numbers))
            # Copying the data several times to make plotting easier later
            for l in numpads:
                numbers[1] = str(l)
                threadspeeds.append(numbers[:])
        datalists.append(threadspeeds)
datalists = np.array(datalists)
with open('Project_3_Data.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerows(data)

# Plot the results
fig = pyl.figure(0, figsize=(10, 6))
x = fig.add_subplot(111)
pyl.title('NUMPAD vs. MegaAdds/second')
pyl.xlabel('NUMPAD')
pyl.xlim(0, numpads[-1])
pyl.ylabel('MegaAdds/second')
# pyl.xticks(numpads)
x.grid(which='both')
# Condition the numbers for plotting
for i in datalists:
    speeds = [float(j) for j in i[:, 3]]
    padnum = [int(j) for j in i[:, 1]]
    if int(i[0, 2]) == 0:
        linelabel = str('Fix #1, ' + i[0, 0] + ' Threads')
        style = '-'
    else:
        linelabel = str('Fix #2, ' + i[0, 0] + ' Threads')
        style = '--'
    pyl.plot(padnum, speeds, label=linelabel, linestyle=style)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)
pyl.savefig('Project_3_Plot.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')
pyl.show()
