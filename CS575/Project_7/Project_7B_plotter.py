#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  1 12:15:00 2017

@author: andrewalferman
"""

import numpy as np
import pylab as pyl
import csv as csv

with open('Project_7B_Data.csv', newline='') as csvfile:
    linereader = csv.reader(csvfile, delimiter=',', quotechar='|')
    data = []
    for row in linereader:
        data.append(row)

data = np.array(data[1:])

pyl.clf()
pyl.cla()

fig = pyl.figure(0)
x = fig.add_subplot(111)
# pyl.xlim(min(nkbs),max(nkbs))
pyl.ylabel('Magnitude')
pyl.xlabel('Shift Number')
x.grid(which='both')
pyl.plot(data[:, 0], data[:, 1], label='Serial CPU')
pyl.plot(data[:, 0], data[:, 2], label='Parallel (OpenMP) CPU')
pyl.plot(data[:, 0], data[:, 3], label='Parallel (SIMD) CPU')
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)

pyl.savefig('Signal_Autocorrelated.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')

pyl.show()
