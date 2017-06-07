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
with open('Project_7B_CL_Data.csv', newline='') as csvfile2:
    linereader2 = csv.reader(csvfile2, delimiter=',', quotechar='|')
    CLdata = []
    for row2 in linereader2:
        CLdata.append(row2)
CLspeedrow = np.array([float(i) for i in CLdata[-1][1:]])
CLdata = np.array(CLdata[1:-1])

print(data[1:10])
print(CLdata[1:10])

# Clear the previous plots
pyl.clf()
pyl.cla()

# Get some better colors going
headings = ['Serial (flip)', 'Serial (rabbit)', 'OpenMP (flip)',
            'OpenMP (rabbit)', 'SIMD (flip)', 'OpenCL (rabbit)']

colormap = pyl.get_cmap('jet')
color = [colormap(i) for i in np.linspace(0, 1, len(headings))]

fig = pyl.figure(0)
x = fig.add_subplot(111)
pyl.xlim(0, 32767)
# pyl.ylim(-80000.0, 80000.0)
pyl.ylabel('Magnitude')
pyl.xlabel('Shift Number')
x.grid(which='both')
pyl.scatter(data[1:, 0], data[1:, 1],
            s=1, label='Serial CPU (flip)', color=color[0])
pyl.scatter(data[1:, 0], data[1:, 2],
            s=1, label='Parallel (OpenMP) CPU (flip)', color=color[1])
pyl.scatter(data[1:, 0], data[1:, 3],
            s=1, label='Parallel (SIMD) CPU (flip)', color=color[2])
pyl.scatter(CLdata[1:, 0], CLdata[1:, 1],
            s=1, label='Serial CPU (rabbit)', color=color[3])
pyl.scatter(CLdata[1:, 0], CLdata[1:, 2],
            s=1, label='Parallel (OpenMP) CPU (rabbit)', color=color[4])
pyl.scatter(CLdata[1:, 0], CLdata[1:, 3],
            s=1, label='Parallel (OPENCL) GPU', color=color[5])
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)

pyl.savefig('Signal_Autocorrelated.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')

pyl.figure(1)
plotdata = [speedrow[0], CLspeedrow[0], speedrow[1], CLspeedrow[1],
            speedrow[2], CLspeedrow[2]]
y_pos = np.arange(len(headings))
pyl.bar(y_pos, plotdata, align='center', alpha=0.5)
pyl.xticks(y_pos, headings, ha='right', rotation=45)
pyl.ylabel('KiloCorrelations/second')

pyl.savefig('Computational_Speeds.pdf', bbox_inches='tight')

fig2 = pyl.figure(2)
x2 = fig2.add_subplot(111)
# pyl.xlim(15000, 15500)
# pyl.ylim(-80000.0, 80000.0)
pyl.ylabel('Magnitude')
pyl.xlabel('Shift Number')
x2.grid(which='both')
pyl.scatter(data[15000:15500, 0], data[15000:15500, 1],
            s=1, label='Serial CPU (flip)', color=color[0])
pyl.scatter(data[15000:15500, 0], data[15000:15500, 2],
            s=1, label='Parallel (OpenMP) CPU (flip)', color=color[1])
pyl.scatter(data[15000:15500, 0], data[15000:15500, 3],
            s=1, label='Parallel (SIMD) CPU (flip)', color=color[2])
pyl.scatter(CLdata[15000:15500, 0], CLdata[15000:15500, 1],
            s=1, label='Serial CPU (rabbit)', color=color[3])
pyl.scatter(CLdata[15000:15500, 0], CLdata[15000:15500, 2],
            s=1, label='Parallel (OpenMP) CPU (rabbit)', color=color[4])
pyl.scatter(CLdata[15000:15500, 0], CLdata[15000:15500, 3],
            s=1, label='Parallel (OPENCL) GPU', color=color[5])
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles2, labels2 = x2.get_legend_handles_labels()
lgd2 = x2.legend(handles2, labels2, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig2.subplots_adjust(right=0.75)

pyl.savefig('Signal_Autocorrelated_Zoomed.pdf', bbox_extra_artists=(lgd2,),
            bbox_inches='tight')

pyl.show()
