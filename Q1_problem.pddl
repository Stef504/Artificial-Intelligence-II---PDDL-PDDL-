(define(problem locate-victim-1)

(:domain locate-victim)

(:objects 
    room1 room2 room3 room4 room5 - location

)
(:init 
    (connected room1 room2)
    (connected room2 room3)
    (connected room3 room4)
    (connected room4 room5)

    (thermal-reading room4 red)
    (visibility room4 probability5)
    (noise-level room4 highdB)

    (robot-at room1)
    (victim-at room4)
)

(:goal (and
    (robot-at room4)
    (victim-found)
    (oxygen-supply)
))

)