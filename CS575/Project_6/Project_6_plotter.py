#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  1 12:15:00 2017

@author: andrewalferman
"""

import numpy as np
import pylab as pyl
import csv as csv

with open('Project_6_data.csv', newline='') as csvfile:
    linereader = csv.reader(csvfile, delimiter=',', quotechar='|')
    data = []
    newdata = []
    for row in linereader:
        data.append(row)
        newrow = []
        for i in row:
            i = i.strip()
            newrow.append(i)
        newdata.append(newrow)
newdata = np.array(newdata[1:])

multdata = np.array([i[1:] for i in newdata if i[0] == 'Multiply'])
multadddata = np.array([i[1:] for i in newdata if i[0] == 'Multiply-Add'])
multdatareduction = np.array([i[1:] for i in newdata
                              if i[0] == 'Multiply+Reduction'])

nkbs = [int(i[0]) for i in multdata if i[1] == '8']
sizes = [int(i[1]) for i in multdata if i[0] == '1']

datalength = len(multdata)
lnkbs = len(nkbs)
lsizes = len(sizes)

colormap = pyl.get_cmap('inferno')
color = [colormap(i) for i in np.linspace(0, 0.9, lnkbs)]

pyl.clf()
pyl.cla()

fig = pyl.figure(0)
x = fig.add_subplot(111)
pyl.xlim(min(nkbs),max(nkbs))
pyl.xlabel('Global Size (kB)')
pyl.ylabel('Speed (GigaCalcs/second)')
x.grid(which='both')
for i in range(lsizes):
    lab = 'Mult LOCAL_SIZE: {}'.format(sizes[i])
    plotdata = multdata[i*lnkbs:(i+1)*lnkbs,3]
    pyl.plot(nkbs, plotdata,label=lab)
for i in range(lsizes):
    lab = 'Mult-Add LOCAL_SIZE: {}'.format(sizes[i])
    plotdata = multadddata[i*lnkbs:(i+1)*lnkbs,3]
    pyl.plot(nkbs, plotdata,label=lab, linestyle='--')
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)
pyl.savefig('Mult_Arraysize.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')
pyl.cla()

fig = pyl.figure(1)
x = fig.add_subplot(111)
pyl.xlim(min(sizes),max(sizes))
pyl.xlabel('Local Size')
pyl.ylabel('Speed (GigaCalcs/second)')
x.grid(which='both')
for i in range(lnkbs):
    lab = 'Mult Global Size: {}'.format(nkbs[i])
    plotdata = [multdata[j*lnkbs+i,3] for j in range(lsizes)]
    pyl.plot(sizes, plotdata,label=lab, color=color[i])
for i in range(lnkbs):
    lab = 'Mult-Add Global Size: {}'.format(nkbs[i])
    plotdata = [multadddata[j*lnkbs+i,3] for j in range(lsizes)]
    pyl.plot(sizes, plotdata,label=lab, color=color[i], linestyle='--')
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1,
               prop={'size':8})
fig.subplots_adjust(right=0.75)
pyl.savefig('Mult_Localsize.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')
pyl.cla()

fig = pyl.figure(2)
x = fig.add_subplot(111)
pyl.xlim(min(nkbs),max(nkbs))
pyl.xlabel('Array sizes')
pyl.ylabel('Speed (GigaCalcs/second)')
x.grid(which='both')
for i in range(lsizes):
    lab = 'Mult-Reduc LOCAL_SIZE: {}'.format(sizes[i])
    pyl.plot(nkbs, multdatareduction[i*lnkbs:(i+1)*lnkbs,3],label=lab)
    pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)
pyl.savefig('Mult_Reduc_Arraysize.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')
pyl.cla()

fig = pyl.figure(3)
x = fig.add_subplot(111)
pyl.xlim(32,256)
pyl.xlabel('Local Size')
pyl.ylabel('Speed (GigaCalcs/second)')
x.grid(which='both')
for i in range(lnkbs):
    lab = 'Mult-Reduc Global Size: {}'.format(nkbs[i])
    plotdata = [multdatareduction[j*lnkbs+i,3] for j in range(lsizes)]
    pyl.plot(sizes, plotdata,label=lab, color=color[i])
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2)
handles, labels = x.get_legend_handles_labels()
lgd = x.legend(handles, labels, bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
fig.subplots_adjust(right=0.75)
pyl.savefig('Mult_Reduc_Localsize.pdf', bbox_extra_artists=(lgd,),
            bbox_inches='tight')

pyl.show()