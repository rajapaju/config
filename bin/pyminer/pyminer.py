#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

field_height = 4
field_width = 10
bombs_number = 10

#создаем пустой массив нужной размерности - игровое поле
#+2 чтобы с краев поля было по одному ряду, чтобы не получить out of range
cell_value = []
for i in range(field_height+2):
    cell_value.append([])       
    for j in range(field_width+2):
        cell_value[i].append(0)

#пустой массив для списка бомб
armed_cell = []
for i in range(bombs_number):
    armed_cell.append(0)

#генерируем номера ячеек для закладки бомб
i=0
while i < bombs_number:
    candidate=random.randint(1,field_height*field_width)
    unique_test=0
    for j in range(i):
        if candidate == armed_cell[j]: #проверка на уникальность
            unique_test=1
            break
    if unique_test == 0:
        armed_cell[i]=candidate
        i+=1

#ставим бомбы на поле по сгенерированным номерам
for i in range(bombs_number):
    y = armed_cell[i]//field_width+1
    if armed_cell[i]%field_width == 0:
        x = field_width
        y-=1
    else:
        x = armed_cell[i]%field_width
    cell_value[y][x]=9

#считаем число бомб в соседних ячейках
for i in range(field_height+2):
    for j in range(field_width+2):
        if cell_value[i][j]>=9:
            cell_value[i-1][j-1]+=1
            cell_value[i-1][j]+=1
            cell_value[i-1][j+1]+=1
            cell_value[i][j-1]+=1
            cell_value[i][j+1]+=1
            cell_value[i+1][j-1]+=1
            cell_value[i+1][j]+=1
            cell_value[i+1][j+1]+=1

#абсолютно ненужный шаг, просто с ним удобнее смотреть промежуточные результаты
for i in range(field_height+2):
    for j in range(field_width+2):
        if cell_value[i][j]>=9:
            cell_value[i][j]='X'

print
print armed_cell  
print
#печатаем игровое поле
for i in range(1,field_height+1):
    for j in range(1,field_width+1):
        print cell_value[i][j],
    print
#~ print
#~ for i in range(field_height+2):
    #~ print cell_value[i]
    
