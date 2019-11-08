(define (domain asfaltado)
(:requirements :durative-actions :typing :fluents)
(:types cisterna pavimentadora compactadora cuadrilla tramo - object)

(:predicates 
		(en ?x - (either cisterna pavimentadora compactadora cuadrilla) ?c - tramo )
		(conectado ?t1 - tramo ?t2 - tramo)
		(disponiblet ?t - tramo)
		(disponiblep ?p - (either cisterna pavimentadora compactadora tramo))
		(disponiblec ?c - cuadrilla)
		;estado del proceso de reparacion
		(estropeado ?t - tramo)

		(compactado ?t - tramo)
		(pavimentado ?t - tramo)

		(no_pintado ?t - tramo)
		(no_vallado ?t - tramo)
		(no_senalizado ?t - tramo)

		(pintado ?t - tramo)
		(vallado ?t - tramo)
		(senalizado ?t - tramo)

		(terminado ?t - tramo)
)

(:functions 
		(distancia ?t1 - tramo ?t2 - tramo)
		(tiempo_compactar)
		(tiempo_pavimentar)
		(tiempo_aplastar)
		(tiempo_pintar)
		(tiempo_vallar)
		(tiempo_senalizar)

		(coste_cisterna)
		(coste_pavimentadora)
		(coste_compactadora)

		(coste_total)
)


(:durative-action compactar
:parameters (?t - tramo)
:duration (= ?duration (tiempo_compactar))
:condition (and 
	(at start (disponiblet ?t))
	(at start (estropeado ?t))
)
:effect (and   
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
	(at start (not (estropeado ?t)))
	(at end (compactado ?t))
))


(:durative-action pavimentar
:parameters (?t - tramo ?p - pavimentadora ?c - cisterna)
:duration (= ?duration (tiempo_pavimentar))
:condition (and 
	(at start (compactado ?t))
	(at start (disponiblet ?t))
	(at start (en ?c ?t))
	(at start (en ?p ?t))
)
:effect (and 
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
	(at start (not (compactado ?t)))
	(at start (increase (coste_total) ( + (coste_cisterna) (coste_pavimentadora))))
	(at end (pavimentado ?t))
))


(:durative-action aplastar
:parameters (?t - tramo ?c - compactadora)
:duration (= ?duration (tiempo_aplastar))
:condition (and 
	(at start (pavimentado ?t))
	(at start (disponiblet ?t))
	(at start (en ?c ?t))
)
:effect (and   
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
	(at start (not (pavimentado ?t)))
	(at start (increase (coste_total) (coste_compactadora) ))
	(at end (no_pintado ?t))
	(at end (no_vallado ?t))
	(at end (no_senalizado ?t))
))


(:durative-action pintar
:parameters (?t - tramo ?c - cuadrilla)
:duration (= ?duration (tiempo_pintar))
:condition (and 
	(at start (no_pintado ?t))
	(at start (disponiblet ?t))
	(at start (en ?c ?t))
)
:effect (and
	(at end (not(no_pintado ?t)))
	(at end (pintado ?t))
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
))


(:durative-action vallar
:parameters (?t - tramo ?c - cuadrilla)
:duration (= ?duration (tiempo_vallar))
:condition (and 
	(at start (no_vallado ?t))
	(at start (disponiblet ?t))
	(at start (en ?c ?t))
)
:effect (and
	(at end (not(no_vallado ?t)))
	(at end (vallado ?t))
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
))


(:durative-action senalizar
:parameters (?t - tramo ?c - cuadrilla)
:duration (= ?duration (tiempo_senalizar))
:condition (and 
	(at start (disponiblet ?t))
	(at start (no_senalizado ?t))
	(at start (en ?c ?t))
)
:effect (and    
	(at end (not(no_senalizado ?t)))
	(at start (not (disponiblet ?t)))
	(at end (disponiblet ?t))
	(at end (senalizado ?t))
))


(:durative-action terminado
:parameters (?t - tramo)
:duration (= ?duration 0)
:condition (and 
	(at start (pintado ?t))
	(at start (vallado ?t))
	(at start (senalizado ?t))
)
:effect (and    
	(at start (not (pintado ?t)))
	(at start (not (vallado ?t)))
	(at start (not (senalizado ?t)))
	(at end (terminado ?t))
))


(:durative-action transporte_maquinaria
:parameters (?t1 - tramo ?t2 - tramo ?m - (either cisterna pavimentadora compactadora))
:duration (= ?duration (* 2 (distancia ?t1 ?t2)))
:condition (and 
	(at start (disponiblet ?t1))
	(at start (disponiblet ?t2))
	(at start (disponiblep ?m))
	(at start (en ?m ?t1))
	(at start (conectado ?t1 ?t2))
)
:effect (and    
	(at start (not (en ?m ?t1)))
	(at start (not (disponiblep ?m)))
	(at end (disponiblep ?m))
	(at end (en ?m ?t2))
))


(:durative-action transporte_cuadrilla
:parameters (?t1 - tramo ?t2 - tramo ?c - cuadrilla)
:duration (= ?duration (distancia ?t1 ?t2))
:condition (and 
	(at start (disponiblet ?t2))
	(at start (disponiblet ?t1))
	(at start (disponiblec ?c))
	(at start (en ?c ?t1))
	(at start (conectado ?t1 ?t2))
)
:effect (and    
	(at start (not (en ?c ?t1)))
	(at start (not (disponiblec ?c)))
	(at end (disponiblec ?c))
	(at end (en ?c ?t2)))
))