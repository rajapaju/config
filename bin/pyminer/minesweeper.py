#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pygtk
pygtk.require('2.0')
import gtk
import random

#Константы
CELL_PLACEHOLDER=" "            #символ для неоткрытой клетки (если оставить пустым, не создастся label, который потом редактируется при открытии)
BOMB_PLACEHOLDER="⚙"            #символ для открытой бомбы
FLAG="⚑"                        #символ для флага
MAIN_WINDOW_TITLE="Minesweeper" #заголовок окна

#Параметры игры
HGHT=9
WDTH=9
BMBS=10

#Визуальные параметры
#(0,1,2,3,4,5,6,7,8,bomb,flag)
COLORS=("#999","#00f","#00a000","#ff0000","#00007f","#a00000","#AA129D","#E1671F","#000","#f00","#f00")
CELL_SIZE=5     #pixels (минимальный размер клетки)
TEXT_SIZE=14    #pt     (если не вписывается в миним.размер клетки, клетка будет увеличена)
MARGINS_SIZE=6  #pixels (Сколько пикселей в высоте кнопки не занято текстом)
RELIEF_OPENED=gtk.RELIEF_NONE #стиль открытых ячеек

#Инициализация глобальных переменных
cell_value = []
visible_value = []
armed_cell = []
cell_flagged = []
cells_opened=0
cell_button=0
game_failed=False

def variables_init():
#функция для обнуления глобальных переменных при начале второй и последующих игр
    global cell_value
    global visible_value
    global armed_cell
    global cell_flagged
    global cells_opened
    global cell_button
    global game_failed
    cell_value = []
    visible_value = []
    armed_cell = []
    cell_flagged = []
    cells_opened=0
    cell_button=0
    game_failed=False

def field_create(field_height, field_width, bombs_number, cell_reserved):
#функция для создания нового игрового поля
    
    #создаем пустые массивы нужной размерности - игровое поле и его видимую часть
    #+2 чтобы с краев поля было по одному лишнему ряду, чтобы не получить out of range
    for i in range(field_height+2):
        cell_value.append([])
        visible_value.append([])
        cell_flagged.append([])
        for j in range(field_width+2):
            cell_value[i].append(0)
            visible_value[i].append(CELL_PLACEHOLDER)
            cell_flagged[i].append(False)
    
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
    global game_failed
    
    if (not 0<row<=HGHT) or (not 0<column<=WDTH):
        #на вспомогательных элементах массива: 0 и WDTH+1 или HGHT+1
        #срабатывать не нужно
        return 0
        
    if cell_value[row][column]==0 and cell_value[row][column]!=visible_value[row][column] and not cell_flagged[row][column]:
    #для нулевых неоткрытых и непомеченным флагом ячеек
        #пометим открытой
        visible_value[row][column]=cell_value[row][column]
        
        #нарисуем пустоту в окне
        cell_color="#000"
        cell_text=CELL_PLACEHOLDER
        cell_button[row][column].props.relief=RELIEF_OPENED
        
        #откроем соседние ячейки
        show_cell(row+1,column+1)
        show_cell(row+1,column)
        show_cell(row+1,column-1)
        show_cell(row,column+1)
        show_cell(row,column-1)
        show_cell(row-1,column+1)
        show_cell(row-1,column)
        show_cell(row-1,column-1)

    elif 0<cell_value[row][column]<9 and cell_value[row][column]!=visible_value[row][column] and not cell_flagged[row][column]:
    #для ненулевых небомб, которые не открыты и не помечены флагом
        #пометим открытой
        visible_value[row][column]=cell_value[row][column]
        #нарисуем число бомб
        cell_color=COLORS[visible_value[row][column]]
        cell_text=visible_value[row][column]
        cell_button[row][column].props.relief=RELIEF_OPENED
        
    elif cell_value[row][column]>=9 and cell_value[row][column]!=visible_value[row][column] and not cell_flagged[row][column]:
    #если открыли бомбу
        #пометить открытой
        visible_value[row][column]=BOMB_PLACEHOLDER
        
        #игра провалена
        game_failed = True
        
        #рисуем символ бомбы
        cell_color=COLORS[9]
        cell_text=visible_value[row][column]
        cell_button[row][column].props.relief=RELIEF_OPENED
        
    elif cell_flagged[row][column]:
    #если поставили флаг
        cell_color=COLORS[10]
        cell_text=FLAG
    else:
    #на уже открытых не срабатывать
        return 0
    
    #Изменяем надпись на ячейке на ту, что определили выше
    cell_button[row][column].get_children()[0].set_markup('<span color="%s" size="%s"><b>%s</b></span>' % (cell_color,TEXT_SIZE*1000,cell_text))

class GameWindow:
    click_is_double=False #чтобы не оставлять неинициализированную переменную

    #Основная функция по клику на ячейке
    def release_event(self, widget, event, data=None):
        global click_is_double
        global cells_opened
        global game_failed
        global visible_value
        global cell_value
        
        #Считываем координаты кликнутой ячейки
        row,column=data
        
        #Если игра доиграна до победы или поражения
        if game_failed or cells_opened >= WDTH*HGHT-BMBS: 
            if game_failed:             #поражение
                print "Game failed"
            else:                       #победа
                print "Game won"
            #Начать следующую игру
            self.game_restart()
            return 0
        
        #Клик левой кнопкой мыши
        if event.button==1:
            if cells_opened==0: #первый клик
                RSRVD=(row-1)*WDTH+column #страхуемся от попадания в бомбу первым шагом
                field_create(HGHT,WDTH,BMBS,RSRVD) #генерируем содержимое поля
            
            #Открыть ячейку
            show_cell(row,column)
            
            #Если клик был двойной, открыть все соседние ячейки
            if click_is_double and not cell_flagged[row][column]:
                for i in row-1,row,row+1:
                    for j in column-1,column,column+1:
                        show_cell(i,j)
            
            #Посчитать, сколько ячеек открыто
            cells_opened=0
            for i in range(1,HGHT+1):
                for j in range(1,WDTH+1):
                    if visible_value[i][j]!=CELL_PLACEHOLDER and visible_value[i][j]!=BOMB_PLACEHOLDER and visible_value[i][j]==cell_value[i][j]:
                        cells_opened+=1
            
        #Клик средней кнопкой мыши
        elif event.button==2:
            pass #пока ничего не делает
            
        #Клик правой кнопкой мыши
        elif event.button==3:
            if cell_flagged[row][column]:
            #если был флаг
                #снять флаг
                cell_flagged[row][column]=False
                #очистить ячейку
                cell_button[row][column].get_children()[0].set_markup(CELL_PLACEHOLDER)
                
            elif visible_value[row][column]!=cell_value[row][column]:
            #если флага не было, и ячейка еще не открыта
                #поставить флаг
                cell_flagged[row][column]=True
                #прорисовать флаг в ячейке
                show_cell(row, column)

    #Только проверка двойного клика. Не добавлять сюда рабочего кода    
    def press_event(self, widget, event):
        global click_is_double
        click_is_double = (event.type == gtk.gdk._2BUTTON_PRESS)

    #Выход по крестику на окне
    def delete_event(self, widget, event, data=None):
        gtk.main_quit()
        return False

    #Новая игра
    def game_new(self):
        global cell_button
        global CELL_SIZE

        #Переинициализация глобальных переменных
        variables_init()
        
        #Контейнер для игрового поля
        #Матрешка: window/vbox_toplevel/vbox_fill/hbox_fill/vbox_field/...
        #_toplevel содержит все элементы окна, а не только поле
        #_fill'ы используются для ценрования при увеличении окна
        vbox_field = gtk.VBox(False, 0) #неплохо бы вокруг него границу обернуть
        self.hbox_fill = gtk.HBox(True, 0) #для выравнивания при ресайзе
        self.vbox_fill=gtk.VBox(True,0)
        self.hbox_fill.pack_start(vbox_field, False, False, 0)
        self.vbox_fill.pack_start(self.hbox_fill,False,False,0)
        self.vbox_toplevel.pack_start(self.vbox_fill, True, True, 0)
        self.hbox_fill.show()
                
        #Инициализируем массивы
        hbox_row=[0,]       #ряд с кнопками
        cell_button=[0,]    #все кнопки
        
        #Замеряем высоту надписей при выбранном размере шрифта
        label = gtk.Label("jjjj")
        label.set_markup('<span size="%s"><b>999999</b></span>' % (TEXT_SIZE*1000))
        if CELL_SIZE < (label.get_layout().get_pixel_size()[1]+MARGINS_SIZE):
            CELL_SIZE = label.get_layout().get_pixel_size()[1]+MARGINS_SIZE
            print "Cell size set to %s pixels automatically" % CELL_SIZE
        label.unmap()
        label.unrealize() #это был только вспомогательный элемент, больше он не нужен
        
        #Рисуем игровое поле
        for i in range(1,HGHT+1):
            hbox_row.append(gtk.HBox(False,0)) #добавляем новый ряд
            cell_button.append([0,])
            for j in range(1,WDTH+1):
                cell_button[i].append(gtk.Button(CELL_PLACEHOLDER)) #добавляем новую кнопку
                cell_button[i][j].connect("button_press_event", self.press_event)
                cell_button[i][j].connect("button_release_event", self.release_event, (i,j))
                hbox_row[i].pack_start(cell_button[i][j], False, False, 0) #ставим кнопку в ряд
                cell_button[i][j].set_size_request(CELL_SIZE,CELL_SIZE)
                cell_button[i][j].show()
            vbox_field.pack_start(hbox_row[i], False, False, 0) #ставим ряд на поле
            hbox_row[i].show()
        
        #не забываем делать все виджеты видимыми
        self.vbox_fill.show()
        vbox_field.show()

    #Рестарт игры
    def game_restart(self, data=None, data2=None):
        #Удаление старого игрового поля
        self.vbox_fill.hide()
        self.vbox_fill.unmap()
        self.vbox_fill.unrealize() 
        #Начало новой игры
        self.game_new()

    def menu_create(self, window):
        accel_group = gtk.AccelGroup()
        item_factory = gtk.ItemFactory(gtk.MenuBar, "<main>", accel_group) #инициализация itemfactory
        item_factory.create_items(self.menu_items) #не забыть передать сюда список
        window.add_accel_group(accel_group)
        self.item_factory = item_factory
        return item_factory.get_widget("<main>")

    #Создаем окно
    def __init__(self):
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title(MAIN_WINDOW_TITLE)
        self.window.connect("delete_event", self.delete_event)

        #Контейнер для элементов окна
        self.vbox_toplevel = gtk.VBox(False, 0)
        self.window.add(self.vbox_toplevel)
        
        #Меню
        self.menu_items = ( #имя, шорткат, функция, параметры, тип пункта
            ("/_File",         None,         None, 0, "<Branch>"),
            ("/File/_New game","F2",         self.game_restart, 0, None),
            ("/File/sep1",     None,         None, 0, "<Separator>"),
            ("/File/_Quit",    "<control>Q", gtk.main_quit, 0, None),
            ("/_Edit",         None,         None, 0, "<Branch>"),
            ("/Edit/_Game options (n\/a)",None,None,0,None),
            ("/Edit/_View options (n\/a)",None,None,0,None),
            )
        menubar=self.menu_create(self.window)
        menubar.show()
        self.vbox_toplevel.pack_start(menubar,False,False,0)

        #Новая игра: и графика, и алгоритм
        self.game_new()

        self.vbox_toplevel.show()
        self.window.show()

def main():
    gtk.main()
    return 0       

if __name__ == "__main__":
    GameWindow()
    main()
