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
  progress-bar: false,
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
  #align(center, image("figs/Example_Vm.PNG", width: 80%))
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

= ¿Dónde se pueden ejecutar las SNNs?

#new-section-slide([], title:[])

== Hardware neuromórfico
#slide()[
    - Hardware para procesamiento de datos.
    #pause
    - A diferencia de hardware "tradicional" (CPU/GPU), las dinámicas de las neuronas están implementadas por circuitos electrónicos#footnote([Existen líneas de investigación alternativas a la electrónica, como por ejemplo fotónica.]) y no por software.
    #pause
    - No ejecutan software. El único control disponible es el peso de conexiones entre neuronas.
]

=== Ejemplo de hardware neuromórfico: neurona láser

#slide(align: center+horizon, composer: (1fr, 2fr, 2fr))[
    #image("figs/VCSEL.png")\
][
    #image("figs/pulso_QIG_nahmias.PNG")\
    @Nahmias_Shastri_Tait_Prucnal_2013
][
    #image("figs/LIF.PNG")\
]

=== Ejemplo de hardware neuromórfico: procesador TrueNorth
#slide()[
    #image("figs/truenortharch.png")
][
    Procesador TrueNorth:
    #pause
    - Procesador neuromórfico para SNNs.
    #pause
    - 1 millón de neuronas LIF.
    #pause
    - 256 millones de conexiones entre neuronas (sinapsis).
    #pause
    - Pesos de 2 bits de precisión.
    #pause
    - Dividido en 4096 cores.
    #pause
    - Salida binaria de neuronas (_"digital en amplitud"_).
    #pause
    - Actualización asincrónica de neuronas (_"analógico en tiempo"_).
    #pause
    - Opcional: estocasticidad en la salida de las neuronas.
]


= ¿Por qué usar SNNs?
#new-section-slide([], title: [])

#slide()[
    - _*Eficiencia energética*_: en muchos casos, el consumo de potencia es mucho menor que otras ANN principalmente debido a que:
        #pause
        - son _event-driven_: las neuronas solo transmiten información (i.e.: un pulso) cuando ocurre un evento.
        #pause
        - las señales de salida son poco densas (_sparse_) debido a que, para cada neurona, la mayor parte del tiempo no hay eventos.#footnote[Esto depende del entrenamiento, pero es posible incluir la cantidad de disparos total de la red como factor en la función de costo para regular el consumo de potencia total de la red.]
    #pause
    - _*Baja latencia*_:
        #pause
        - Como son _event-driven_, los eventos se propagan en el momento que ocurren.
        #pause
        - Como se comunican únicamente con pulsos, todos los mensajes transmitidos son muy cortos.
]
#slide()[
    - _*Apropiadas para procesamiento series temporales*_: 
        - Como las neuronas tienen memoria de su entrada en el pasado, no hace falta una arquitectura recurrente para procesar temporales.
    #pause
    - _*Similitud a redes neuronales biológicas*_: son más cercanas a las redes neuronales biológicas, lo que puede ser útil para modelar y estudiar su comportamiento.
]

== ¿Qué es una cámara de eventos?
#focus-slide[Caso de uso: procesamiento de salida de cámaras de eventos.]

#slide(title:"¿Qué es una cámara de eventos?", composer: (1.3fr, 1fr))[
    #image("figs/camera_comparison.png")
][
    - Cámaras inspiradas en sistemas visuales biológicos:
        #pause
        - Mayor sensibilidad a grandes cambios de intensidad que a intensidad constante.
        #pause
        - _Event-driven_: solo se guarda la información de eventos (cambios). Donde no hay cambios no se guarda información.
]

#slide(title:"¿Qué es una cámara de eventos?", composer: (1.3fr, 1fr))[
    #image("figs/camera_comparison.png")
][
    - La salida es un arreglo de estructuras iguales con 3 datos (no se guardan frames completos!):
        - Posición del evento
        - Timestamp del evento:
        - Polaridad del evento
    #pause
    #sym.arrow.double Comparada con una cámara de frames convencional, tiene:
    - Menos volumen de datos de salida
    - Más detalle del movimiento
]

#slide(align:center+horizon, composer: (15fr, 1fr))[
    #image("figs/frame_vs_event_based_dataset.png", height: 80%)][
    @gesture_recognition_2017
]

#slide(align:center+horizon, composer: (15fr, 1fr))[
    #image("figs/frame_vs_event_based_rocks.png")][
    @Hendy_Merkel_2022
]

== Procesamiento de salida de una cámara de eventos con SNNs
#slide(align: center+horizon)[
    #text(size: 24pt)[Por el formato de los datos de salida de una cámara de eventos,\
    las SNNs son ideales para procesarlos!]
]
#slide(align:center+horizon, composer: (15fr, 1fr))[
    #image("figs/gesture_recognition_arch.png")][
    @gesture_recognition_2017
]

#slide[
    #todo-inline[Explicar la parte de SNN del paper]
]

#slide[
    - Resultados:
        - Latencia promedio de 105ms en reconocimiento de gestos (percibido como en tiempo real por un humano)
        - Accuracy de entre 87.62% (para consumo de 88.5mW) y 96.44% (para consumo de 178.8mW) 
            #pause
            - #sym.arrow Un cargador de notebook de 60W alcanza para alimentar el análisis de 300 streams de video en tiempo real!
]

= ¿Cómo se entrenan las SNNs?
#new-section-slide([], title: [])

#slide[
  #todo-inline[supervisado vs no supervisado (probablemente volar)]
  #todo-inline[supervisado: backpropagation y gradient descent, desafio de la no derivabilidad]
]

// = Referencias
#slide()[
  #bibliography("refs.bib", title: [Referencias])
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

