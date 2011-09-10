#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random

#Надписи для игры в консоли
CELL_PLACEHOLDER="."    #символ для неоткрытой клетки
BOMB_PLACEHOLDER="&"    #символ для открытой бомбы
BOMB_PRINTED="*"        #символ для закрытой бомбы


def field_create(field_height, field_width, bombs_number, cell_reserved):
#функция для создания нового игрового поля
    
    #создаем пустые массивы нужной размерности - игровое поле и его видимую часть
    #+2 чтобы с краев поля было по одному лишнему ряду, чтобы не получить out of range
    for i in range(field_height+2):
        cell_value.append([])
        visible_value.append([])
        for j in range(field_width+2):
            cell_value[i].append(0)
            visible_value[i].append(CELL_PLACEHOLDER)
    
    #пустой массив для списка бомб
    for i in range(bombs_number):
        armed_cell.append(0)
    
    #генерируем номера ячеек для закладки бомб
    i=0
    while i < bombs_number:
        candidate=random.randint(1,field_height*field_width)
        unique_test=0
        for j in range(i):
            if candidate == armed_cell[j] or candidate == cell_reserved: #проверка на уникальность
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

def show_cell(row, column):
#функция показа пользователю ячейки
#первая координата - по вертикали, вторая - по горизонтали
    if cell_value[row][column]==0 and cell_value[row][column]!=visible_value[row][column] and 0<row<=HGHT and 0<column<=WDTH:
        visible_value[row][column]=cell_value[row][column]
        show_cell(row+1,column+1)
        show_cell(row+1,column)
        show_cell(row+1,column-1)
        show_cell(row,column+1)
        show_cell(row,column-1)
        show_cell(row-1,column+1)
        show_cell(row-1,column)
        show_cell(row-1,column-1)
    elif cell_value[row][column]<9:
        visible_value[row][column]=cell_value[row][column]
    elif cell_value[row][column]>=9:
        visible_value[row][column]=BOMB_PLACEHOLDER

def field_print(field):
#печатаем игровое поле
    print
    for i in range(1,HGHT+1):
        for j in range(1,WDTH+1):
            if field[i][j]>=9 and field[i][j] != CELL_PLACEHOLDER and field[i][j] != BOMB_PLACEHOLDER:
                print BOMB_PRINTED,
            else:
                print field[i][j],
        print

def game_new():
#функция с игровым процессом
    
    #первый ход
    y,x=input()
    RSRVD=(y-1)*WDTH+x #страхуемся от попадания в бомбу первым шагом
    field_create(HGHT,WDTH,BMBS,RSRVD) #генерируем содержимое поля
    show_cell(y,x) #открываем первую ячейку
    cells_opened=1
    game_failed=0
    
    field_print(cell_value)
    field_print(visible_value)
    
    while cells_opened < WDTH*HGHT-BMBS:
        y,x=input() #делаем ход
        show_cell(y,x) #открываем ячейку
        if cell_value[y][x]>=9: #проверяем, есть ли там бомба
            game_failed=1
            break
        
        field_print(visible_value)
        
        #считаем, сколько уже открыто ячеек
        cells_opened=0
        for i in range(1,HGHT+1):
            for j in range(1,WDTH+1):
                if visible_value[i][j]!=CELL_PLACEHOLDER and visible_value[i][j]!=BOMB_PLACEHOLDER:
                    cells_opened+=1
    
    #подводим итоги
    if game_failed==1:
        print "GAME OVER"
    else:
        print "YOU WON!"
    print "Another game? (1/0)"
    answer=input()
    return answer

#устанавливаем параметры на первую игру
cell_value = []
visible_value = []
armed_cell = []
HGHT = 9         #высота поля
WDTH = 9         #ширина поля
BMBS = 10        #число бомб
while game_new()==1:
    #возвращаем параметры к изначальным для каждой следующей игры
    cell_value = []
    visible_value = []
    armed_cell = []
    HGHT = 9         #высота поля
    WDTH = 9         #ширина поля
    BMBS = 10        #число бомб
    #RSRVD = 5       #порядковый номер ячейки, в которую никогда не ставить бомбу
