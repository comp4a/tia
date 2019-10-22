(define (domain asfaltado)
(:requirements :durative-actions :typing :fluents)
(:types cisterna pavimentadora compactadora cuadrilla tramo - object)
(:predicates (en ?x - (either cisterna pavimentadora compactadora cuadrilla) ?c - tramo )
             (conectado ?t1 - tramo ?t2 - tramo)
             
             (disponible ?t - tramo)
             (agrietado ?t - tramo)

             (compactado ?t - tramo)
             (pavimentado ?t - tramo)
             (aplastado ?t - tramo)

             (pintado ?t - tramo)
             (vallas ?t - tramo)
             (señales ?t - tramo)

             (terminado ?t - tramo)
)
(:functions (distancia ?t - tramo ?t - tramo)
            (tiempo_compactado)
)


(:durative-action compactar
 :parameters (?t - tramo ?c - compactadora)
 :duration (= ?duration (tiempo_compactado))
 :condition (and (at start (disponible ?t))
                 (at start (agrietado ?t))
                 (at start (en ?c ?t)))
 :effect (and (at start (not (at ?p ?c)))
              (at end (in ?p ?a))))

(:durative-action debark
 :parameters (?p - person ?a - aircraft ?c - city)
 :duration (= ?duration (debarking-time))
 :condition (and (at start (in ?p ?a))
                 (over all (at ?a ?c)))
 :effect (and (at start (not (in ?p ?a)))
              (at end (at ?p ?c))))

(:durative-action fly 
 :parameters (?a - aircraft ?c1 ?c2 - city)
 :duration (= ?duration (/ (distance ?c1 ?c2) (slow-speed ?a)))
 :condition (and (at start (at ?a ?c1))
                 (at start (>= (fuel ?a) 
                         (* (distance ?c1 ?c2) (slow-burn ?a)))))
 :effect (and (at start (not (at ?a ?c1)))
              (at end (at ?a ?c2))
              (at end (increase (total-fuel-used)
                         (* (distance ?c1 ?c2) (slow-burn ?a))))
              (at end (decrease (fuel ?a) 
                         (* (distance ?c1 ?c2) (slow-burn ?a)))))) 
                                  
(:durative-action zoom
 :parameters (?a - aircraft ?c1 ?c2 - city)
 :duration (= ?duration (/ (distance ?c1 ?c2) (fast-speed ?a)))
 :condition (and (at start (at ?a ?c1))
                 (at start (>= (fuel ?a) 
                         (* (distance ?c1 ?c2) (fast-burn ?a)))))
 :effect (and (at start (not (at ?a ?c1)))
              (at end (at ?a ?c2))
              (at end (increase (total-fuel-used)
                         (* (distance ?c1 ?c2) (fast-burn ?a))))
              (at end (decrease (fuel ?a) 
                         (* (distance ?c1 ?c2) (fast-burn ?a)))))) 

(:durative-action refuel
 :parameters (?a - aircraft ?c - city)
 :duration (= ?duration (/ (- (capacity ?a) (fuel ?a)) (refuel-rate ?a)))
 :condition (and (at start (> (capacity ?a) (fuel ?a)))
                 (over all (at ?a ?c)))
 :effect (at end (assign (fuel ?a) (capacity ?a))))


)
