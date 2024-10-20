#!/bin/bash

#verifica que el usuario ingrese un archivo
if [ $# -eq 1 ];then
	cat $1 > infractores.txt
	if [ $(wc -c <infractores.txt) -ne 0 ];then  #verifica que el archivo no este vacio

		#cantidad de lineas
		n=$(cat infractores.txt | wc -l) 

		#funciones

		#devuelve el anio
		obtener_anio(){
			sed -r -n "$1 p" infractores.txt | grep -P -o "([0-9]{4}(?= ,)|[0-9]{4}(?=,))"
		}
	
		#devuelve el tiempo
		obtener_tiempo(){
			sed -r -n "$1 p" $2 | grep -E -o "([0-9]|[0-9]{2}|[0-9]{3}|[0-9]{4})$"
		}
	
		#intercambia lineas
		swap(){
			lin_n1=$(sed -r -n "$1 p" $3)
			lin_n2=$(sed -r -n "$2 p" $3)
			sed -r -i -e "$1 s|.*$|AUX|g" -e "$2 s|.*$|${lin_n1}|g" -e "$1 s|AUX|${lin_n2}|g" $3
		
		}
	

		#agrupar anios (de menor a mayor)
	
		for ((i=1;i<=$n;i++))do
			for ((j=$i;j<=$n;j++))do
				if [ "$(obtener_anio $j)" -lt "$(obtener_anio $i)" ];then
					swap $i $j infractores.txt
				fi
			done
		done
	
		#ordenar por tiempos
		
		for ((i=1;i<=$n;i++))do
			for ((j=$i;j<=$n;j++))do
				if [ "$(obtener_anio $j)" -eq "$(obtener_anio $i)" ];then
					if [ "$(obtener_tiempo $j infractores.txt )" -lt "$(obtener_tiempo $i infractores.txt )" ];then
						swap $i $j infractores.txt
					fi
				fi
			done
		done

	
		#Mejores tiempos historicos

		
		cat infractores.txt > aux.txt
		
		for ((i=1;i<=$n;i++))do
			for ((j=$i;j<=$n;j++))do
				if [ "$(obtener_tiempo $j aux.txt)" -lt "$(obtener_tiempo $i aux.txt)" ];then
					swap $i $j aux.txt
				fi
			done
		done
		
		grep -E -m 3 ".*$" aux.txt > acertijo3.txt 
		
		cat infractores.txt

	fi
fi
