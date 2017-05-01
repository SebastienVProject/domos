#!/bin/bash

if [ $# -ne 2 ]
then
	echo "[ERROR] Nombre d'arguments incorrects"
	exit 12
fi

codeBarre=$1
quantite=$2

clear
# Récupération d'informations produit à partir d'un code barre
fichierCourses="./listeDeCourses.txt"

#Utilisation API permettant de récupérer des infos produit dans une base communautaire
infoProduit=`curl http://world.openfoodfacts.org/api/v0/product/${codeBarre}.json`

#On teste si un produit a été trouvé ou nom dans l'api
statusVerbose=`echo $infoProduit | jq '.status_verbose'`
if [ "<$statusVerbose>" = '<"product not found">' ]
then
	produitTrouve=false
else
	produitTrouve=true
fi

#Actions à exécuter si produit trouvé
if $produitTrouve 
then
	ingredients=`echo $infoProduit | jq '.product.ingredients_text_with_allergens'`
	libelleProduit=`echo $infoProduit | jq '.product.generic_name_fr'`
	imageProduit=`echo $infoProduit | jq '.product.image_ingredient_small_url'`
	brands=`echo $infoProduit | jq '.product.brands'`


	echo $ingredients
	echo $libelleProduit
	echo $imageProduit
	echo $brands
fi

#Ajout du produit dans la liste de courses
enregistrement=`grep $codeBarre $fichierCourses`
if [ "$enregistrement" = ""  ]
then
	if [ $quantite -gt 0 ]
	then
		echo "${codeBarre}|${quantite}|${libelleProduit}|${brands}|${ingredients}|${imageProduit}" >> $fichierCourses
	fi
else
	quantitePrecedente=`echo $enregistrement | cut -d'|' -f2`
	sed -i "/^${codeBarre}/d" $fichierCourses
	quantite=`expr $quantite + $quantitePrecedente`
	if [ $quantite -gt 0 ]
	then
		echo "${codeBarre}|${quantite}|${libelleProduit}|${brands}|${ingredients}|${imageProduit}" >> $fichierCourses
	fi
fi

exit 0
