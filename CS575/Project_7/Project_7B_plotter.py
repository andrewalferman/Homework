#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  1 12:15:00 2017

@author: andrewalferman
"""

import numpy as np
import pylab as pyl
import csv as csv

# Get the data from flip
with open('Project_7B_Data.csv', newline='') as csvfile:
    linereader = csv.reader(csvfile, delimiter=',', quotechar='|')
    data = []
    for row in linereader:
        data.append(row)
speedrow = np.array([float(i) for i in data[-1][1:]])
data = np.array(data[1:-1])

# Get the data from rabbit
with open('Project_7B_CLData.csv', newline='') as csvfile:
    linereader = csv.reader(csvfile, delimiter=',', quotechar='|')
    CLdata = []
    for row in linereader:
        CLdata.append(row)
CLspeedrow = np.array([float(i) for i in CLdata[-1][1:]])
CLdata = np.array(data[1:-1])

# Clear the previous plots
pyl.clf()
pyl.cla()

fig = pyl.figure(0)
x = fig.add_subplot(111)
#pyl.xlim(0, 32767)
#pyl.ylim(-80000.0, 80000.0)
pyl.ylabel('Magnitude')
pyl.xlabel('Shift Number')
x.grid(which='both')
pyl.scatter(data[1:, 0], data[:, 1], label='Serial CPU (flip)')
pyl.scatter(data[1:, 0], data[:, 2], label='Parallel (OpenMP) CPU (flip)')
pyl.scatter(data[1:, 0], data[:, 3], label='Parallel (SIMD) CPU (flip)')
pyl.scatter(CLdata[1:, 0], CLdata[:, 1], label='Serial CPU (rabbit)')
pyl.scatter(CLdata[1:, 0], CLdata[:, 2], label='Parallel (OpenMP) CPU (rabbit)')
pyl.scatter(CLdata[1:, 0], CLdata[:, 3], label='Parallel (OPENCL) GPU')
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)

pyl.savefig('Signal_Autocorrelated.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')

headings = ['Serial (flip)', 'Serial (rabbit)', 'OpenMP (flip)',
            'OpenMP (rabbit)', 'SIMD (flip)', 'OpenCL (rabbit)']
y_pos = np.arange(len(headings))
pyl.figure(1)
plotdata = [speedrow[0], CLspeedrow[0], speedrow[1], CLspeedrow[1],
            speedrow[2], CLspeedrow[2]]
pyl.bar(y_pos, plotdata, align='center', alpha=0.5)
pyl.xticks(y_pos, headings)
pyl.ylabel('KiloCorrelations/second')

pyl.savefig('Computational_Speeds.png')

pyl.show()
