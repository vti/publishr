#!/usr/bin/python

import sys
import Skype4Py

if len(sys.argv) < 3:
    sys.exit('Usage: <chat> <message>')

skype = Skype4Py.Skype()

skype.Attach()

for elem in skype.Chats:
    if elem.Topic == sys.argv[1]:
        elem.SendMessage(sys.argv[2])
