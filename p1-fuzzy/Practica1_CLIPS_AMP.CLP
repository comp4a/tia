;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCIÓN FUSIFICAR EXTRAIDA DEL APARTADO 2.3 DEL BOLETÍN ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deffunction fuzzify (?fztemplate ?value ?delta)

        (bind ?low (get-u-from ?fztemplate))
        (bind ?hi  (get-u-to   ?fztemplate))

        (if (<= ?value ?low)
          then
            (assert-string
              (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
          else
            (if (>= ?value ?hi)
              then
                (assert-string
                   (format nil "(%s (%g 0.0) (%g 1.0))"
                               ?fztemplate (- ?hi ?delta) ?hi))
              else
                (assert-string
                   (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
                               ?fztemplate (max ?low (- ?value ?delta))
                               ?value (min ?hi (+ ?value ?delta)) ))
            )
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CLASE/HECHO ESTRUCTURADO: Carretera ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Los slots de los hechos estructurados solo pueden contener valores crisp (no difusos)
; Más información en el anexo de la página 12 del boletín
(deftemplate carretera
	(slot id (type SYMBOL))
	(slot agrietamiento (type FLOAT))
	(slot temperaturaMin (type FLOAT))
	(slot temperaturaMax (type FLOAT))
	(slot trafico (type INTEGER))
	(slot prioridad_reasflatado (type FLOAT))
)                   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DECLARACIÓN DE HECHOS CON VALORES DIFUSOS/HEXHOS NO ESTRUCTURADOS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftemplate agrietamiento 0 100 porcentaje
	( 	(ligero (10 1) (20 0))
		(medio (5 0) (25 1) (45 1) (55 0))
		(fuerte (50 0) (60 1))
	)
)
		
(deftemplate temperatura -10 90 Celsius
	( 	(fria (5 1) (10 0))
		(moderada (5 0) (15 1) (40 1) (50 0))
		(calida (35 0) (45 1))
	)
)
		
(deftemplate necesidad_reasfaltado 0 100 prioridad
	( 	(baja (z 10 25))
		(media (pi 15 60))
		(urgente (s 55 90))
	)
)

(deftemplate trafico 0 300 prioridad
	( 	(baja (z 20 80))
		(alta (s 120 250))
	)
)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGLA PARA LEER POR CONSOLA ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;lee de consola un valor crisp y aserta su valor fusificado
(defrule leerconsola
	(initial-fact)
=>
	(printout t "Introduzca el identificador de la carretera" crlf)
	(bind ?Rid (read))
	(printout t "Introduzca el grado de degradacion del asfalto (0 - 100)" crlf)
	(bind ?Rasf (read))
	(printout t "Introduzca la temperatura extrema maxima a la que se vio sometida la carretera" crlf)
	(bind ?Rtmin (read))
	(printout t "Introduzca la temperatura extrema minima a la que se vio sometida la carretera" crlf)
	(bind ?Rtmax (read))
	(printout t "Introduzca el numero de vehiculos que transitan la carretera por hora" crlf)
	(bind ?Rtraf (read))
	 
	(fuzzify agrietamiento ?Rasf 0.1)
	(fuzzify temperatura ?Rtmax 0.1)
	(fuzzify temperatura ?Rtmin 0.1)
	(fuzzify trafico ?Rtraf 0.1)
	
	(assert (carretera (id ?Rid) (agrietamiento ?Rasf) (temperaturaMin ?Rtmin)
			(temperaturaMax ?Rtmax) (trafico ?Rtraf))) 
)
	
;;;;;;;;;;;;
;; REGLAS ;;
;;;;;;;;;;;;
; Basadas en la tabla de la página 15 del boletín
(defrule estimacion1
 	(agrietamiento ligero)
	(temperatura fria)
 =>
 	(assert (necesidad_reasfaltado media))
)

(defrule estimacion2
 	(agrietamiento ligero)
	(temperatura moderada)
 =>
 	(assert (necesidad_reasfaltado very baja))
)

(defrule estimacion3
 	(agrietamiento ligero)
	(temperatura calida)
 =>
 	(assert (necesidad_reasfaltado media))
)

(defrule estimacion4
 	(agrietamiento medio)
	(temperatura fria)
 =>
 	(assert (necesidad_reasfaltado urgente))
)

(defrule estimacion5
 	(agrietamiento medio)
	(temperatura moderada)
 =>
 	(assert (necesidad_reasfaltado baja))
)

(defrule estimacion6
 	(agrietamiento medio)
	(temperatura calida)
 =>
 	(assert (necesidad_reasfaltado very urgente))
)

(defrule estimacion7
 	(agrietamiento fuerte)
	(temperatura fria)
 =>
 	(assert (necesidad_reasfaltado extremely urgente))
)

(defrule estimacion8
 	(agrietamiento fuerte)
	(temperatura moderada)
 =>
 	(assert (necesidad_reasfaltado somewhat media))
)

(defrule estimacion9
 	(agrietamiento fuerte)
	(temperatura calida)
 =>
 	(assert (necesidad_reasfaltado extremely urgente))
)

(defrule estimacion10
 	(trafico baja)
 =>
 	(assert (necesidad_reasfaltado extremely urgente))
)

(defrule estimacion11
 	(trafico alta)
 =>
 	(assert (necesidad_reasfaltado more-or-less baja))
)

;;;;;;;;;;;;;;;;;
;; DEFUSIFICAR ;;
;;;;;;;;;;;;;;;;;
(defrule defusificar
	(declare (salience -2))
	?fc <- 	(carretera (id ?Rid) (agrietamiento ?Rasf) (temperaturaMin ?Rtmin)
			(temperaturaMax ?Rtmax) (trafico ?Rtra))
	?fn <- (necesidad_reasfaltado ?)
=>
	(bind ?pra (maximum-defuzzify ?fn))
	(assert (carretera (id ?Rid) (agrietamiento ?Rasf) 
			(temperaturaMin ?Rtmin) (temperaturaMax ?Rtmax)
			(trafico ?Rtra) (prioridad_reasflatado ?pra)))
        (retract ?fc)
	(printout t "La prioridad es de " ?pra crlf)
        (halt)
)




