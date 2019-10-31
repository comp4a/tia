(define (problem asfaltado-1)
(:domain asfaltado)
(:objects
;cisterna pavimentadora compactadora cuadrilla tramo
    Cuadrilla1 - cuadrilla
    Cuadrilla2 - cuadrilla
    Cuadrilla3 - cuadrilla
    Cuadrilla4 - cuadrilla

    Cisterna1 - cisterna
    Cisterna2 - cisterna
    Pavimentadora1 - pavimentadora
    Pavimentadora2 - pavimentadora
    Compactadora1 - compactadora

	Tramo1 - tramo
	Tramo2 - tramo
	Tramo3 - tramo
	Tramo4 - tramo
	Tramo5 - tramo
)
(:init
    (disponiblec Cuadrilla1)
    (disponiblec Cuadrilla2)
    (disponiblec Cuadrilla3)
    (disponiblec Cuadrilla4)

    (disponiblep Cisterna1)
    (disponiblep Cisterna2)
    (disponiblep Pavimentadora1)
    (disponiblep Pavimentadora2)
    (disponiblep Compactadora1)

    (disponiblet Tramo1)
    (disponiblet Tramo2)
    (disponiblet Tramo3)
    (disponiblet Tramo4)
    (disponiblet Tramo5)

    (en Cuadrilla1 Tramo1)
    (en Cuadrilla2 Tramo1)
    (en Cuadrilla3 Tramo5)
    (en Cuadrilla4 Tramo5)

    (en Cisterna1 Tramo1)
    (en Cisterna2 Tramo1)
    (en Pavimentadora1 Tramo2)
    (en Pavimentadora2 Tramo2)
    (en Compactadora1 Tramo5)

    (estropeado Tramo1)
    (no_necesita_senalizado Tramo1)
    (estropeado Tramo2)
    (no_necesita_senalizado Tramo2)
    (estropeado Tramo3)
    (no_necesita_compactado Tramo3)
    (estropeado Tramo4)
    (no_necesita_compactado Tramo4)
    (estropeado Tramo5)
    (no_necesita_compactado Tramo5)

    (conectado Tramo1 Tramo2)
    (conectado Tramo2 Tramo3)
    (conectado Tramo2 Tramo4)
    (conectado Tramo3 Tramo5)
    (conectado Tramo4 Tramo5)

    (conectado Tramo2 Tramo1)
    (conectado Tramo3 Tramo2)
    (conectado Tramo4 Tramo2)
    (conectado Tramo5 Tramo3)
    (conectado Tramo5 Tramo4)

    (= (distancia Tramo1 Tramo2) 5)
    (= (distancia Tramo2 Tramo1) 5)

    (= (distancia Tramo2 Tramo3) 6)
    (= (distancia Tramo3 Tramo2) 6)

    (= (distancia Tramo2 Tramo4) 4)
    (= (distancia Tramo4 Tramo2) 4)

    (= (distancia Tramo3 Tramo5) 7)
    (= (distancia Tramo5 Tramo3) 7)

    (= (distancia Tramo4 Tramo5) 6)
    (= (distancia Tramo5 Tramo4) 6)


    (= (tiempo_compactar) 250)
    (= (tiempo_pavimentar) 190)
    (= (tiempo_aplastar) 150)
    (= (tiempo_pintar) 30)
    (= (tiempo_vallar) 120)
    (= (tiempo_senalizar) 70)

    (= (coste_cisterna) 25)
    (= (coste_pavimentadora) 30)
    (= (coste_compactadora) 35)

    (= (coste_total) 1000)
)
(:goal (and
    (terminado Tramo1)
    (terminado Tramo2)
    (terminado Tramo3)
    (terminado Tramo4)
    (terminado Tramo5)

    (en Cuadrilla1 Tramo1)
    (en Cuadrilla2 Tramo5)
    (en Cuadrilla4 Tramo5)

    (en Cisterna1 Tramo1)
    (en Cisterna2 Tramo3)
    (en Compactadora1 Tramo5)

))

(:metric minimize (+ (* 0.2 (total-time))  (* 0.5 (coste_total))))
)
