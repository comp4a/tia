; TODO: añadir costes
; TODO: añadir transporte
(define (domain asfaltado)
(:requirements :durative-actions :typing :fluents)
(:types cisterna pavimentadora compactadora cuadrilla tramo - object)

(:predicates (en ?x - (either cisterna pavimentadora compactadora cuadrilla) ?c - tramo )
             (conectado ?t1 - tramo ?t2 - tramo)
             ;estado del proceso de reparacion
             (estropeado ?t - tramo)

             (no_necesita_compactado ?t - tramo)
             (no_necesita_señalizado ?t - tramo)

             (compactado ?t - tramo)
             (pavimentado ?t - tramo)
             (aplastado ?t - tramo)

             (no_pintado ?t - tramo)
             (no_vallado ?t - tramo)
             (no_señalizado ?t - tramo)

             (pintado ?t - tramo)
             (vallado ?t - tramo)
             (señalizado ?t - tramo)

             (terminado ?t - tramo)
)

(:functions (distancia ?t - tramo ?t - tramo)
            (tiempo_compactar)
            (tiempo_pavimentar)
            (tiempo_aplastar)
            (tiempo_pintar)
            (tiempo_vallar)
            (tiempo_señalizar)

            (coste_cisterna)
            (coste_pavimentadora)
            (coste_compactadora)
)

;En el caso de que no se necesario compactar se compacta automaticamente y sin costes
(:durative-action no_compactar
 :parameters (?t - tramo)
 :duration (= ?duration 0)
 :condition (and (at start (no_necesita_compactado ?t))
                 (at start (estropeado ?t)))
 :effect (and (at start (not (estropeado ?t)))
              (at end (compactado ?t))))

;TODO: no se que herramientas hacen falta, no es la compactadora
(:durative-action compactar
 :parameters (?t - tramo)
 :duration (= ?duration (tiempo_compactar))
 :condition (and (at start (estropeado ?t)))
 :effect (and (at start (not (estropeado ?t)))
              (at end (compactado ?t))))

(:durative-action pavimentar
 :parameters (?t - tramo ?p - pavimentadora ?c - cisterna)
 :duration (= ?duration (tiempo_pavimentar))
 :condition (and (at start (compactado ?t))
                 (at start (en ?c ?t))
                 (at start (en ?p ?t)))
 :effect (and (at start (not (compactado ?t)))
              (at end (pavimentado ?t))))

(:durative-action aplastar
 :parameters (?t - tramo ?c - compactadora)
 :duration (= ?duration (tiempo_aplastar))
 :condition (and (at start (pavimentado ?t))
                 (at start (en ?c ?t)))
 :effect (and (at start (not (pavimentado ?t)))
              (at end (no_pintado ?t))
              (at end (no_vallado ?t))
              (at end (no_señalizado ?t))))



(:durative-action pintar
 :parameters (?t - tramo ?c - cuadrilla)
 :duration (= ?duration (tiempo_pintar))
 :condition (and (at start (no_pintado ?t))
                 (at start (en ?c ?t)))
 :effect (and    (at end (pintado ?t))))

(:durative-action vallar
 :parameters (?t - tramo ?c - cuadrilla)
 :duration (= ?duration (tiempo_vallar))
 :condition (and (at start (no_vallado ?t))
                 (at start (en ?c ?t)))
 :effect (and    (at end (vallado ?t))))

;En el caso de que no sea necesario el señalizado se señaliza automaticamente y sin costes
(:durative-action no_señalizar
 :parameters (?t - tramo)
 :duration (= ?duration 0)
 :condition (and (at start (no_necesita_señalizado ?t))
                 (at start (no_señalizado ?t)))
 :effect (and    (at end (señalizado ?t))))

(:durative-action señalizar
 :parameters (?t - tramo ?c - cuadrilla)
 :duration (= ?duration (tiempo_señalizar))
 :condition (and (at start (no_señalizar ?t))
                 (at start (en ?c ?t)))
 :effect (and    (at end (señalizado ?t))))




(:durative-action terminado
 :parameters (?t - tramo)
 :duration (= ?duration 0)
 :condition (and (at start (pintado ?t))
                 (at start (vallado ?t))
                 (at start (señalizado ?t)))
 :effect (and    (at start (not (pintado ?t)))
                 (at start (not (vallado ?t)))
                 (at start (not (señalizado ?t)))
                 (at end (terminado ?t))))




(:durative-action transporte_maquinaria
 :parameters (?t1 - tramo)
 :duration (= ?duration 0)
 :condition (and (at start (pintado ?t))
                 (at start (vallado ?t))
                 (at start (señalizado ?t)))
 :effect (and    (at start (not (pintado ?t)))
                 (at start (not (vallado ?t)))
                 (at start (not (señalizado ?t)))
                 (at end (terminado ?t))))

(:durative-action transporte_cuadrilla
 :parameters (?t - tramo)
 :duration (= ?duration 0)
 :condition (and (at start (pintado ?t))
                 (at start (vallado ?t))
                 (at start (señalizado ?t)))
 :effect (and    (at start (not (pintado ?t)))
                 (at start (not (vallado ?t)))
                 (at start (not (señalizado ?t)))
                 (at end (terminado ?t))))