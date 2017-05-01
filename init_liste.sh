#!/bin/bash

fichierCourses="./listeDeCourses.txt"

#on vide le fichier contenant la liste des courses
rm -f $fichierCourses
touch $fichierCourses
chmod 777 $fichierCourses

exit 0
