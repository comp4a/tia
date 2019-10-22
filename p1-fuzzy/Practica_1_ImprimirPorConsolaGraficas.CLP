;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMANDOS PARA IMPRIMIR POR CONSOLA LAS GRÁFICAS ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOLO POR CONSOLA
(plot-fuzzy-value t "*+#" 0 100
        (create-fuzzy-value agrietamiento ligero)
        (create-fuzzy-value agrietamiento medio)
        (create-fuzzy-value agrietamiento fuerte)
)

(plot-fuzzy-value t "*+#" -10 90
        (create-fuzzy-value temperatura fria)
        (create-fuzzy-value temperatura moderada)
        (create-fuzzy-value temperatura calida)
)

(plot-fuzzy-value t "*+#" 0 100
        (create-fuzzy-value necesidad_reasfaltado baja)
        (create-fuzzy-value necesidad_reasfaltado media)
        (create-fuzzy-value necesidad_reasfaltado urgente)
)

(plot-fuzzy-value t "*+" 0 300
        (create-fuzzy-value trafico baja)
        (create-fuzzy-value trafico alta)
)