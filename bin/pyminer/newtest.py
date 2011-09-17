#!/usr/bin/env python

import gtk

window = gtk.Window ()
box    = gtk.VButtonBox ()

for k in range (10):
    button = gtk.Button ('button %d' % k)
    if k % 2 == 0:
        button.props.relief = gtk.RELIEF_NONE

    box.add (button)

window.add (box)
window.show_all ()

gtk.main ()
