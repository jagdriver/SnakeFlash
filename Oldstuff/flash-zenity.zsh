#!/bin/bash

# Zenity test






zenity --calendar

zenity --entry --title "Name request" --text "Please enter your name:"

zenity --file-selection --multiple --filename "${HOME}/"

