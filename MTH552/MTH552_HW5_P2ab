#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 22 20:01:28 2017

@author: alfermaa
"""

import numpy as np

a0 = -3/4
a1 = -1/2
a2 = 1/4
a3 = 1.
b0 = 5/8
b1 = 0.
b2 = 19/8
b3 = 0.

c0 = a0 + a1 + a2 + a3
c1 = -b0 + a1 - b1 + 2*a2 - b2 + 3*a3 - b3
c2 = a1 - 2*b1 + 4*a2 - 4*b2 + 9*a3 - 6*b3
c3 = a1 - 3*b1 + 8*a2 - 12*b2 + 27*a3 - 27*b3
c4 = a1 - 4*b1 + 16*a2 - 32*b2 + 81*a3 - 108*b3

print('c0 = {}'.format(c0))
print('c1 = {}'.format(c1))
print('c2 = {}'.format(c2))
print('c3 = {}'.format(c3))
print('c4 = {}'.format(c4))

coeff = [a3,a2,a1,a0]
roots = np.roots(coeff)
print('Roots: {}'.format(roots))