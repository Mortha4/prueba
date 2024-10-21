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
		

		  #Guardar anios en lista
 
                  lista_anios=()
                  anio_1=$(obtener_anio 1)
                  lista_de_anios+=("$anio_1")
                  for((i=2;i<=$n;i++))do
                          anio_encontrado=0
                          for anio_lista in ${lista_de_anios[@]} ;do
                                  if [ "$(obtener_anio $i)" -eq "$anio_lista" ];then
                                          anio_encontrado=1
                                  fi
                          done
  
                          if [ "$anio_encontrado" -eq 0 ];then
                                  anio_n=$(obtener_anio $i)
                                  if [ "$anio_n" -ge 2019 ];then
                                          lista_de_anios+=("$anio_n")
                                  fi
                          fi
                  done
	          >temp.txt
 
                  #Mejores 3 tiempos de cada anio
  
                 for anio_lista in ${lista_de_anios[@]} ;do
                          grep -m 3 -P  "${anio_lista}" infractores.txt >> temp.txt
                 done
 
                 cat temp.txt > infractores.txt

	
		#Mejores tiempos historicos
		cat infractores.txt | sort -t',' -k3,3n > acertijo3.txt
		
		cat infractores.txt > aux.txt
		
		
		cat infractores.txt

	fi
fi
