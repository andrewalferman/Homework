#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr  5 19:20:18 2017

@author: andrewalferman
"""

import os
import subprocess as sp
import re

filename = 'Project_5_Alferman'

# Delete the old compiled code if it exists
try:
    os.remove(filename)
except Exception:
    pass

# Initialize lists for determining speedup later
peak, average = [], []

# Run the c code and get performance data, printing the data along the way
for i in [1000*2**x for x in range(1, 15)]:
    # print('NUMT ={}'.format(i))
    command = str(('g++-6 -DARRAYSIZE={} ').format(i) +
                  filename + '.cpp -o ' + filename + ' -lm -fopenmp')
    os.system(command)
    command = './' + filename
    output = str(sp.check_output(command, shell=True)).replace('\\n', '\n')
    output = output.replace("b'   ", "")
    numbers = re.findall('[\d.]+', output)
    peak.append(float(numbers[0]))
    average.append(float(numbers[1]))
    print(output)

# Analyze the data
peakspeedup = peak[1] / peak[0]
averagespeedup = average[1] / average[0]
peakparallelfraction = (4. / 3.) * (1. - (1. / peakspeedup))
avgparallelfraction = (4. / 3.) * (1. - (1. / averagespeedup))

# Print the output of the analysis
print('Peak Value Speedup: {:.3f}'.format(peakspeedup))
print('Average Value Speedup: {:.3f}'.format(averagespeedup))
print('Peak Parallel Fraction: {:.3f}'.format(peakparallelfraction))
print('Average Parallel Fraction: {:.3f}'.format(avgparallelfraction))
