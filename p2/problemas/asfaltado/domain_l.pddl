(define (domain asfaltado)

    ; Requisitos que ha de ser capaz de soportar el planificador
    ; para trabajar este dominio
    ; durative-actions -> las acciones tienen principio-duración-final
    ; typing -> los predicados tienen tipo
    ; fluents -> funciones numéricas
    (:requirements :durative-actions :typing : fluents)

    ; Tipos del dominio
    ;   tramo -> Unidad de terreno a trabajar
    ;   cisterna -> Maquinaria Pesada requerida para realizar la Pavimentación
    ;   pavimentadora -> IDEM
    ;   compactadora -> MP requerida para realizar el Aplastado
    ;   cuadrilla -> grupo de trabajadores requerido para realizar ciertas acciones
    (:types tramo cisterna pavimentadora compactadora cuadrilla)

    ; Predicados, puden ser ciertos o falsos dependiendo el estadp actual en
    ; el problema (representan información booleana)
    (:predicates 
        ; Nos permite conocer en que tramo está la maquinaria o las cuadrillas
        (en ?u - (either cuadrilla pavimentadora compactadora cisterna) ?t - tramo)
        ; Nos permite conocer si un tramo está compactado o deteriorado
        (compactado ?t - tramo)
        ; Nos permite conocer si un tramo está pavimentado
        (pavimentado ?t - tramo)
        ; Nos permite conocer si un tramo está aplastado
        (aplastado ?t - tramo)
        ; Nos permite conocer si un tramo tiene vallas y quitamiedos
        (vallado ?t - tramo)
        ; Nos permite conocer si un tramo tiene pintado de marcas varias
        (pintado ?t - tramo)
        ; Nos permite conocer si un tramo tiene señales y paneles luminosos
        (senyalizado ?t - tramo)
        ; Nos permite conocer si un tramo, una maquina o una cuadrilla están disponibles
        ; Un tramo no está disponible si está realizando alguna acciónj
        ; Una maquina/cuadrilla no está disponible si está realizando alguna acción
        (disponible ?t - (either cuadrilla pavimentadora compactadora cisterna tramo))
        ; Cuando un tramo tiene realizadas las obras finales requeridas pasa a estar terminado
        (terminado ?t - tramo)
    )

    ; Permiten representar información numérica del estado actual
    (:functions
        ; Indica la distancia, en unidades de tiempo, de un tramo a otro
        ; en base a lo que tardaria un móvil de velocidad 1 en recorrerla
        (distancia ?t1 - tramo ?t2 - tramo)

        ; Velocidad base de todas las cuadrillas
        (velocidad-cuadrilla)
        ; Velocidad base de toda la maquinaria pesada
        (velocidad-pesada)

        ; Coste de usar la cisterna de asfalto
        (coste-cisterna)
        ; Coste de usar la pavimentadora
        (coste-pavimentadora)
        ; Coste de usar la compactadora de aplastado
        (coste-compactadora)
        ; Coste acumulado de realizar las obras
        (coste-total)

        ; Duracion de acciones de obras
        (duracion-compactado)
        (duracion-pavimentado)
        (duracion-aplastado)
        (duracion-pintado)
        (duracion-vallado)
        (duracion-senyalizado)
    )

    ; Las acciones tienen: nombre, lista de parámetros,
    ; precondiciones, efectos y duración
    ; Se cumplen las precondiciones -> Se producen los efectos

    ; Acción de compactado
    (:durative-action Compactar
        ; Requerimos saber sobre el terreno y una cuadrilla para determinar esta acción
        :parameters (?t - tramo ?cd - cuadrilla)
        ; El compactado dura 250 Uds
        :duration (= ?duration (duracion-compactado))
        ; Si el tramo no está compactado es porque está deteriorado
        ; Si está deteriorado y disponible pasamos a compactarlo
        :condition (and (at start (not (compactado ?t)))
                        (at start (disponible ?t))
                        (at start (disponible ?cd))
                        (over all (en ?cd ?t))
                   )
        ; Cuando se empiece a compactar dejará de estar disponible
        ; El terreno estará listo de nuevo al acabar
        ; Al acabar el terreno estará compactado
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?cd)))
                     (at end (disponible ?t))
                     (at end (disponible ?cd))
                     (at end (compactado ?t))
                )

    )

    ; Acción de pavimentación
    (:durative-action Pavimentar
        ; Requerimos saber sobre el tramo, las cisterna y la pavimentadora para esta acción
        :parameters (?t - tramo ?c - cisterna ?p - pavimentadora)
        ; La pavimentación dura 190 Uds
        :duration (= ?duration 190)
        ; El tramo no debe estar pavimentado y debe estar disponible
        ; Lss máquinas deberen permanecer en el tramo durante la realización
        ; de la acción y deben estar disponibles desde el comienzo
        :condition (and (at start (not (pavimentado ?t)))
                        (at start (disponible ?t))
                        (at start (disponible ?c))
                        (at start (disponible ?p))
                        (over all (en ?c ?t))
                        (over all (en ?p ?t))
                   )
        ; Empieza la acción:
        ;       Las máquinas y el tramo dejan de estar disponibles
        ; Acaba la acción:
        ;       Las máquinas quedan disponbles y el tramo pavimentado (y disponible)
        ;       Se añade el coste de la maquinaria al coste total      
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?c)))
                     (at start (not (disponible ?p)))
                     (at end (increase (coste-total) (coste-cisterna)))
                     (at end (increase (coste-total) (coste-pavimentadora)))
                     (at end (disponible ?t))
                     (at end (disponible ?c))
                     (at end (disponible ?p))
                     (at end (pavimentado ?t))
                )
    )

    ; Acción de aplastado
    (:durative-action Aplastar
        ; Requerimos saber sobre el tramo y la compactadora para esta acción
        :parameters (?t - tramo ?cp - compactadora)
        ; El aplastado dura 150 Uds
        :duration (= ?duration 150)
        ; El tramo no debe estar aplastado y debe estar disponible
        ; Lss máquinas deberen permanecer en el tramo durante la realización
        ; de la acción y deben estar disponibles desde el comienzo
        :condition (and (at start (not (aplastado ?t)))
                        (at start (disponible ?t))
                        (at start (disponible ?cp))
                        (over all (en ?cp ?t))
                   )
        ; Empieza la acción:
        ;       Las máquinas y el tramo dejan de estar disponibles
        ; Acaba la acción:
        ;       Las máquinas quedan disponbles y el tramo pavimentado (y disponible)
        ;       Se añade el coste de la maquinaria al coste total 
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?cp)))
                     (at end (increase (coste-total) (coste-compactadora)))
                     (at end (disponible ?t))
                     (at end (disponible ?cp))
                     (at end (aplastado ?t))
                )
    )

    ; Acción de pintado de marcas varias
    (:durative-action Pintar
        ; Requerimos saber sobre el tramo y una cuadrilla para esta acción
        :parameters (?t - tramo ?cd - cuadrilla)
        ; El pintado de marcas varias dura 30 Uds
        :duration (= ?duration 30)
        ; El tramo debe estar aplastado, disponible y no pintado
        ; La cuadrilla debe estar disponible
        :condition (and (at start(disponible ?t))
                        (at start(disponible ?cd))
                        (at start(not (pintado ?t)))
                        (at start(aplastado ?t))
                   )
        ; Empieza la acción:
        ;      El tramo y la cuadrilla dejan de estar disponibles
        ; Acaba la acción:
        ;      El terreno vuelve a estar disponible (y la cuadrilla) y está pintado 
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?cd)))
                     (at end (disponible ?t))
                     (at end (disponible ?cd))
                     (at end (pintado ?t))
                )
    )

    ; Acción de colocación de vallas y quitamiedos
    (:durative-action Vallar
        ; Requerimos saber sobre el tramo y una cuadrilla para esta acción
        :parameters (?t - tramo ?cd - cuadrilla)
        ; El vallado dura 120 Uds
        :duration (= ?duration 120)
        ; El tramo debe estar aplastado, disponible y no vallado
        ; La cuadrilla debe estar disponible
        :condition (and (at start(disponible ?t))
                        (at start(disponible ?cd))
                        (at start(not (vallado ?t)))
                        (at start(aplastado ?t))
                   )
        ; Empieza la acción:
        ;      El tramo y la cuadrilla dejan de estar disponibles
        ; Acaba la acción:
        ;      El terreno vuelve a estar disponible (y la cuadrilla) y está vallado 
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?cd)))
                     (at end (disponible ?t))
                     (at end (disponible ?cd))
                     (at end (vallado ?t))
                )
    )

    ; Acción de colocación de señales y carteles luminosos
    (:durative-action Senyalizar
        ; Requerimos saber sobre el tramo y una cuadrilla para esta acción
        :parameters (?t - tramo ?cd - cuadrilla)
        ; El señalizado dura 70 Uds
        :duration (= ?duration 70)
        ; El tramo debe estar aplastado, disponible y no señalizado
        ; La cuadrilla debe estar disponible
        :condition (and (at start(disponible ?t))
                        (at start(disponible ?cd))
                        (at start(not (senyalizado ?t)))
                        (at start(aplastado ?t))
                   )
        ; Empieza la acción:
        ;      El tramo y la cuadrilla dejan de estar disponibles
        ; Acaba la acción:
        ;      El terreno vuelve a estar disponible (y la cuadrilla) y está señalizado 
        :effect (and (at start (not (disponible ?t)))
                     (at start (not (disponible ?cd)))
                     (at end (disponible ?t))
                     (at end (disponible ?cd))
                     (at end (senyalizado ?t))
                )
    )

    ; Acción de transportar maquinaria pesada
    (:durative-action Transporte-Pesado
        ; Requerimos saber sobre los tramos y que es maquinaria pesada
        :parameters (?t1 - tramo ?t2 - tramo ?mp - (either cisterna pavimentadora compactadora))
        ; El transporte de maquinaria pesada dura en función de la distancia entre tramos
        ; y la velocidad de desplazamiento de la maquinaria pesada
        :duration (= ?duration (* (distancia ?t1 ?t2) velocidad-pesada))
        ; La máquina debe estar en el tramo de inicio y disponible
        :condition (and (at start (disponible ?mp))
                        (at start (en ?mp ?t1))
                   )
        ;  
        :effect (and (at start (not (disponible ?mp)))
                     (at start (not (en ?mp ?t1)))
                     (at end (disponible ?mp))
                     (at end (en ?mp ?t2))
                )
    )

    ; Acción de transportar cuadrillas
    (:durative-action Transporte-Cuadrilla
        ; Requerimos saber sobre los tramos y que cuadrilla
        :parameters (?t1 - tramo ?t2 - tramo ?cd - cuadrilla)
        ; El transporte de maquinaria pesada dura en función de la distancia entre tramos
        ; y la velocidad de desplazamiento de la maquinaria pesada
        :duration (= ?duration (distancia ?t1 ?t2))
        ; La cuadrilla debe estar en el tramo de inicio y disponible
        :condition (and (at start (disponible ?cd))
                        (at start (en ?cd ?t1))
                   )
        ;  
        :effect (and (at start (not (disponible ?cd)))
                     (at start (not (en ?cd ?t1)))
                     (at end (disponible ?cd))
                     (at end (en ?cd ?t2))
                )
    )

    ; Acción de finalizar obras del tramo
    (:durative-action Terminar
        ; Requerimos saber sobre el tramo
        :parameters (?t - tramo)
        ; La acción de finalizar es instantaea una vez se cumplan las condiciones
        :duration (= ?duration 0)
        ; El tramo debe tener todas las condiciones de obra final
        :condition (and (at start (disponible ?t))
                        (at start (senyalizado ?t))
                        (at start (pintado ?t))
                        (at start (vallado ?t))
                   )
        ; El terreno pasa a estar terminado y no disponible
        :effect (and (at end (terminado ?t))
                     (at end (not (disponible ?t)))
                )
    )


)