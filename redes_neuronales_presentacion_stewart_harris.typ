#import "@preview/touying:0.5.5": *
#import "@preview/clean-math-presentation:0.1.1": *
#import "@preview/subpar:0.2.2"
#import "@preview/fletcher:0.5.3": diagram, node, edge
#import "@preview/dashy-todo:0.1.3": todo

#let todo-inline(content) = {
  todo(position: "inline", stroke: rgb(255,0,0))[#content]
}

#set grid(gutter: 10pt)

#show: clean-math-presentation-theme.with(
  config-info(
    title: [Spiking Neural Networks],
    short-title: [Spiking Neural Networks],
    authors: (
      (name: "María Luz Stewart Harris")),
    author: "María Luz Stewart Harris",
    date: datetime(year: 2025, month: 11, day: 26),
  ),
  config-common(
    slide-level: 3,
    // handout: true,
    // show-notes-on-second-screen: right,
  ),
  progress-bar: true,
  align: horizon
)

#title-slide(
  logo1: image("figs/Instituto-Balseiro.png", height: 4.5em),
)

#slide()[
    *#outline(title: [])*
]

= ¿Qué es una SNN?
#new-section-slide([], title: [])

#slide(title: "Spiking Neural Networks")[
  #definition(title: "Spiking Neural Networks / SNN", blocktitle: "Definición")[
    Redes neuronales artificiales en el que el único intercambio que ocurre entre neuronas es el de pulsos de igual amplitud en diferentes instantes. @Maass_1997
  ]
  #pause
  - _*Inspiración de redes biológicas*_: la comunicación entre neuronas biológicas sucede a través de señales eléctricas que contienen pulsos: \
  #align(center, image("figs/Example_Vm.PNG", width: 50%))
]

#slide(title: "Spiking Neural Networks")[
  - En una SNN, la información se codifica exclusivamente por la posición de los pulsos transmitidos.
  - La amplitud y la forma de los pulsos *_no_* aportan más información.
]

== Neuronas de una SNN

#slide()[
_*Características necesarias de las neuronas de una SNN:*_][
    #pause
    - *_Memoria_*: Su salida en $t=t_0$ depende de la entrada en $t<=t_0$.#footnote[Aplica a neuronas individuales, indpendientemente de si la arquitectura de la red implementa memoria a través de recurrencia.]
    #pause
    - *_Event-driven_*: no transmiten información todo el tiempo, solamente cuando ocurrió un evento.
    #pause
    - *_Async_*: generan un disparo apenas detectan un evento, sin tener que esperar a otras neuronas.
]

#slide(title: "Leaky Integrate-and-Fire")[
  - Existen muchos modelos matemáticos de neuronas apropiados para una SNN, entre ellos el modelo _Leaky Integrate-and-Fire_ (LIF).
  #grid(align: (center+horizon, center+horizon), columns: (1fr, 1fr),
    [
    $
      cases(
        dot(s)(t) = 1/tau_s [s_("rest")-s(t)] + x(t),
        y(t) = sum_i^oo delta(t-t_f_i),
        s(t_(f_i) ^+) = s_("rest") ,
      )
    $],
    [
    #image("figs/LIF.PNG", height: 50%)
    ]
  )
]

== Codificación de información en una SNN

#slide()[
    *_Métodos de codificación de estímulo de entrada en pulsos:_*
][
    - _*Rate encoding*_: Convierte intensidad del estímulo de entrada en una tasa de disparos.
    - _*Temporal encoding*_: Convierte intensidad del estímulo de entrada en un tiempo de disparo.
    - _*Delta modulation*_: Convierte _cambios_ de intensidad del estímulo de entrada en disparos
]

#slide(align:center+horizon)[
    #image("figs/spike_encoding.png", width: 80%)
    @snntorch_2023
]

= ¿Por qué usar SNNs?
#new-section-slide([], title: [])

#slide()[
    - _*Eficiencia energética*_: en muchos casos, el consumo de potencia es mucho menor principalmente debido a que:
        - son _event-driven_: las neuronas solo transmiten información (i.e.: un pulso) cuando ocurre un evento.
        - las señales de salida son poco densas (_sparse_) debido a que, para cada neurona, la mayor parte del tiempo no hay eventos.#footnote[Esto depende del entrenamiento, pero es posible incluir la cantidad de disparos total de la red como factor en la función de costo para regular el consumo de potencia total de la red.]
    #pause
    - _*Baja latencia*_:
    #todo-inline[]
]
#slide()[
    - _*Apropiadas para procesamiento series temporales*_: 
        - Como las neuronas tienen memoria su entrada en el pasado, no hace falta una arquitectura recurrente para procesar temporales.
        - #todo-inline[]
    #pause
    - _*Similitud a redes neuronales biológicas*_: son más cercanas a las redes neuronales biológicas, lo que puede ser útil para modelar y estudiar su comportamiento.
]

== SNNs aplicadas a series temporales
#slide(title: [DNNs vs. SNNs], composer: (1fr, 2fr))[
    _*Comparación entre DNNs y SNNs para aplicación de computer vision: @Hendy_Merkel_2022*_
][
    #let color-cell(name, color) = (table.cell(fill: color, text(fill: white, name)))
    #table(
        columns: (1fr, 1fr, 1fr),
        align: (left, center, center),
        fill: (x,y) => if x==0 or y==0 {
            gray.lighten(20%)
        },
        stroke: gray.lighten(40%),
        inset: (left:1.5em, right:1.5em),
        table.header([], [DNNs], [SNNs]),
        [Procesamiento de datos], color-cell([Basado en frames], red), color-cell([Basado en eventos], green),
        [Latencia], color-cell([Alta], red), color-cell([Baja], green),
        [Diferenciable], color-cell([Sí], green), color-cell([No], red),
        // [Activación], [ReLU, Sigmoide, etc.], [Pulsos],
        [Complejidad de neurona], color-cell([Baja], green), color-cell([Alta], red),
        [Memoria a corto plazo], color-cell([Nivel red], red), color-cell([Nivel red y neuronal], green),
        [Eficiencia energética#footnote([Considerando hardware neuromórfico específico para cada caso.])], color-cell([Baja], red), color-cell([Alta], green)
    )
]


== Hardware neuromórfico 
#slide()[
    #todo-inline[Hardware neuromorfico, por que y que existe comercialmente / semicomercialmente]
]

== Caso de uso: cámaras de eventos.
#focus-slide[Caso de uso: cámaras de eventos.]

// #slide(align:horizon)[
//     _*Cámara de eventos*_: Cámaras inspiradas en sistemas visuales biológicos:
//     #align(center)[
//         #image("figs/camera_comparison.png", height: 80%)
//     ]
// ]

#slide[
    #image("figs/camera_comparison.png")
][
    - Cámaras inspiradas en sistemas visuales biológicos:
        #pause
        - Mayor sensibilidad a grandes cambios de intensidad que a intensidad constante.
        #pause
        - _Event-driven_: solo se guarda la información de eventos (cambios). Donde no hay cambios no se guarda información.
        #pause
]

#slide[
    #image("figs/camera_comparison.png")
][
    - La salida es un arreglo de estructuras iguales con 3 datos (no se guardan frames completos!):
        - Posición del evento
        - Timestamp del evento:
        - Polaridad del evento
    #sym.arrow.double Comparada con una cámara de frames convencional, tiene:
    - Menos volumen de datos
    - Más detalle del movimiento
]



#slide[
    #todo-inline[tabla de comparacion entre frame based y event based camaras.]
    #todo-inline[Combinacion con camara frame based]
    - ventajas:
        - muy baja latencia, muy bajo motion blur, muy baja redundancia de datos

]

= ¿Cómo se entrenan las SNNs?
#new-section-slide([], title: [])

#slide[
  #todo-inline[supervisado vs no supervisado]
  #todo-inline[supervisado: backpropagation y gradient descent, desafio de la no derivabilidad]
]

#slide[
  #todo-inline[Ejemplo snntorch. El de las estrellas quizas?]
]



#focus-slide[Muchas gracias! 🧠]


#show: appendix
#set heading(outlined: false)

= Leaky Integrate-and-Fire

#slide(title: "Leaky Integrate-and-Fire")[
  #definition(title: "Modelo Leaky Integrate-and-Fire (LIF)", blocktitle:"Definición")[
  $
    cases(
      dot(s)(t) = 1/tau_s [s_("rest")-s(t)] + x(t),
      y(t) = sum_i^oo delta(t-t_f_i),
      s(t_(f_i) ^+) = s_("rest") ,
    )
  $ <eq:LIF>
  - $t_f_i$: $t$ tal que $s(t) >= s_(t h),$
  - $x(t)$: entrada (pulsos)
  - $s(t)$: estado de la neurona
  - $y(t)$: tren de deltas (disparos)
  ]
]

= Referencias
#slide(title: "Referencias")[
  #bibliography("refs.bib", title: [Referencias])
]