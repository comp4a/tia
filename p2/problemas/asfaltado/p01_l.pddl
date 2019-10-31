; Puede haber varios problemas para un mismo dominio, pero
; solo puede haber un dominio por problema
; El nombre de la instancia del problema...
(define (problem asfaltado-1)
; para el dominio asfaltado
(:domain asfaltado)

; En esta instancia del problema hay...
(:objects
    ; 5 tramos
    Tramo1 - tramo
    Tramo2 - tramo
    Tramo3 - tramo
    Tramo4 - tramo
    Tramo5 - tramo
    ; 4 Cuadrillas
    Cuadrilla1 - cuadrilla
    Cuadrilla2 - cuadrilla
    Cuadrilla3 - cuadrilla
    Cuadrilla4 - cuadrilla
    ; 2 cisternas
    Cisterna_asfalto1 - cisterna
    Cisterna_asfalto2 - cisterna
    ; 2 pavimentadoras
    Pavimentadora1 - pavimentadora
    Pavimentadora2 - pavimentadora
    ; 1 compactadora
    Compactadora1 - compactadora
)


; Estado inicial del problema actual.
; Importante: es necesario inicializar todos los predicados y detallar el valor de todas funciones que
; se van a usar en el problema ya que, de otra forma, el problema no estaría correctamente definido.
; Si un predicado proposicional aparece en “init” se inicializa con el valor cierto, y falso en caso
; contrario. Si se trata de una función numérica hay que inicializarla con un valor numérico concreto
; NOTA: se deben inicializar los valores de todas las funciones que se vayan a utilizar. De lo contrario el
; comportamiento puede ser inesperado.
(:init
    ; Tramos en los que comienzan las cuadrillas
    (en Cuadrilla1 Tramo1)
    (en Cuadrilla2 Tramo1)
    (en Cuadrilla3 Tramo5)
    (en Cuadrilla4 Tramo5)
    ; Tramos en los que comienzan las cisternas de asfalto
    (en Cisterna_asfalto1 Tramo1)
    (en Cisterna_asfalto2 Tramo1)
    ; Tramos en los que comienzan las pavimentadoras
    (en Pavimentadora1 Tramo2)
    (en Pavimentadora2 Tramo2)
    ; Tramos en los que comienzan la compactadora
    (en Compactadora1 Tramo5)

    ; Los tramos 3, 4, 5 no necesitan compactado
    (compactado Tramo3)
    (compactado Tramo4)
    (compactado Tramo5)

    ; Los tramos 1 y 2 no necesitan ser señalizados
    (señalizado Tramo1)
    (señalizado Tramo2)

    ; El coste de usar la maquinaria es para cada una:
    (= (coste-cisterna) 25)
    (= (coste-pavimentadora) 30)
    (= (coste-compactadora) 35)
    ; El coste acumukado empieza siendo 0
    (= (coste-total) 0)

    ; La velocidad de la cuadrilla le permite avanzar 1 unidad de distancia a cada paso
    (= velocidad-cuadrilla 1)
    ; La maquinaria pesada se desplaza el doble de lento que las cuadrillas
    (= velocidad-pesada 0.5)

    ; La distancia entre tramos es:
    (= (distancia Tramo1 Tramo2) 5)
    (= (distancia Tramo2 Tramo3) 6)
    (= (distancia Tramo2 Tramo4) 4)
    (= (distancia Tramo3 Tramo5) 7)
    (= (distancia Tramo4 Tramo5) 6)
    

 ; Las condiciones para acabar son..
 (:goal
    (and
        ; Todos los tramos tienen que haber terminado sus obras
        (terminado Tramo1)
        (terminado Tramo2)
        (terminado Tramo3)
        (terminado Tramo4)
        (terminado Tramo5)

        ; La siguiente maquinaria y cuadrillas deben terminar en los tramos indicado
        (en Cuadrilla1 Tramo1)
        (en Cuadrilla2 Tramo5)
        (en Cuadrilla4 Tramo5)
        (en Cisterna_asfalto1 Tramo1)
        (en Cisterna_asfalto2 Tramo3)
        (en Compactadora1 Tramo5)
    )
)   
    
  ;La función objetivo viene dada por la siguiente métrica
  (:metric minimize (+ (* 0.2 (total-time)) (* 0.5 (coste-total))))
    
)
