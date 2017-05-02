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

filename = 'Project_1_Alferman'

# Initialize lists for determining speedup later
megaHeights, volumes = [], []

# Run the c code and get performance data, printing the data along the way
minpow = 7
threadslist = [1, 2, 4]
nodeslist = [2**x for x in range(minpow, minpow+8)]
for i in threadslist:
    for j in nodeslist:
        # Delete the old compiled code if it exists
        try:
            os.remove(filename + '.out')
        except Exception:
            pass

        # Run the commands to compile the code and run it, then read the output
        command = str(('g++-6 -DNUMT={} -DNUMNODES={} ').format(i, j) +
                      filename + '.cpp -o ' + filename +
                      '.out -lm -fopenmp -O3')
        os.system(command)
        command = './' + filename + '.out'
        output = str(sp.check_output(command, shell=True)).replace('\\n', '\n')
        output = output.replace("b'", "")
        numbers = re.findall('[\d.]+', output)
        megaHeights.append(float(numbers[0]))
        volumes.append(float(numbers[1]))
        print(output)

# Analyze the data
nodetries = len(nodeslist)
basespeeds = megaHeights[0:nodetries]
twothreadspeeds = megaHeights[nodetries:nodetries*2]
fourthreadspeeds = megaHeights[nodetries*2:]
onevols = volumes[0:nodetries]
twovols = volumes[nodetries:nodetries*2]
fourvols = volumes[nodetries*2:]
speedups2t = [twothreadspeeds[i]/basespeeds[i] for i in range(nodetries)]
formatted2t = ['%.4f' % i for i in speedups2t]
speedups4t = [fourthreadspeeds[i]/basespeeds[i] for i in range(nodetries)]
formatted4t = ['%.4f' % i for i in speedups4t]
onethreadmax = max(basespeeds)
twothreadmax = max(twothreadspeeds)
fourthreadmax = max(fourthreadspeeds)
twospeedup = twothreadmax / onethreadmax
fourspeedup = fourthreadmax / onethreadmax
pfs2t = [2 * (1 - 1/i) for i in speedups2t]
pfs4t = [(4/3) * (1 - 1/i) for i in speedups4t]
pfs2tf = ['%.4f' % i for i in pfs2t]
pfs4tf = ['%.4f' % i for i in pfs4t]
pf2t = 2 * (1 - 1/twospeedup)
pf4t = (4/3) * (1 - 1/fourspeedup)
nodes = []
for i in range(nodetries):
    nodes.append([basespeeds[i], twothreadspeeds[i], fourthreadspeeds[i]])
nodes = np.array(nodes)

print('SPEED INFORMATION ------------')
print('One thread speeds:')
print(basespeeds)
print('Two thread speeds:')
print(twothreadspeeds)
print('Four thread speeds:')
print(fourthreadspeeds)
print('Two thread speedups:')
print(formatted2t)
print('Two thread speedup: {:.2f}'.format(twospeedup))
print('Four thread speedups:')
print(formatted4t)
print('Four thread speedup: {:.2f}'.format(fourspeedup))
print('Two thread parallel fractions:')
print(pfs2tf)
print('Overall 2 thread parallel fraction: {:.4f}'.format(pf2t))
print('Four thread parallel fractions:')
print(pfs4tf)
print('Overall 4 thread parallel fraction: {:.4f}'.format(pf4t))
print('Max speedup possible: {:.2f}'.format(1/(1-pf4t)))
print('VOLUME INFORMATION------------')
print('One thread volumes:')
print(onevols)
print('Two thread volumes:')
print(twovols)
print('Four thread volumes:')
print(fourvols)

fs = 14

pyl.figure(0, dpi=600)
pyl.title('Speedup Ratio vs. Number of Nodes', fontsize=fs+2)
pyl.xlabel('Number of Nodes', fontsize=fs)
pyl.ylabel('Speedup Ratio', fontsize=fs)
pyl.plot(nodeslist, speedups2t, label='2 Threads')
pyl.plot(nodeslist, speedups4t, label='4 Threads')
pyl.grid(which='both')
pyl.legend(loc=4)
pyl.savefig('Speedup_Nodes.png')

pyl.figure(1, dpi=600)
pyl.title('Computed Volume vs. Number of Nodes', fontsize=fs+2)
pyl.xlabel('Number of Nodes', fontsize=fs)
pyl.ylabel('Computed Volume', fontsize=fs)
pyl.plot(nodeslist, onevols, label='1 Thread')
pyl.plot(nodeslist, twovols, label='2 Threads')
pyl.plot(nodeslist, fourvols, label='4 Threads')
pyl.grid(which='both')
pyl.legend(loc=4)
pyl.savefig('Computed_volume')

pyl.figure(2, dpi=600)
pyl.title('Speed vs. Number of Threads')
pyl.xlabel('Number of Threads')
pyl.ylabel('MegaHeights per Second')
for i in range(nodetries):
    pyl.plot(threadslist, nodes[i], label='{} Nodes'.format(nodeslist[i]))
pyl.xticks(threadslist, threadslist)
pyl.grid(which='both')
pyl.legend(bbox_to_anchor=(1.05, 1), loc=2, ncol=1)
pyl.savefig('Speedup_Threads', bbox_inches='tight')
