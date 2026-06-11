(define(problem explore-building-1)

(:domain explore-building)

(:objects 
    room1 room2 room3 room4 room5 - location
    
)

(:init
    (connected room1 room2)
    (connected room2 room3)
    (connected room3 room4)
    (connected room4 room5)

    (robot-at room1)

    (thermal-reading room1 blue)
    (chemical-level room1 low)
    
    (thermal-reading room2 orange)
    (chemical-level room2 low)

    (thermal-reading room3 yellow)
    (chemical-level room3 low)

    (thermal-reading room4 green)
    (chemical-level room4 medium)

    (thermal-reading room5 red)
    (chemical-level room5 high)

    (visibility room1 probability1)
    (visibility room2 probability3)
    (visibility room3 probability2)
    (visibility room4 probability4)
    (visibility room5 probability5)

    

)

(:goal(and
    (victim-found)
    (oxygen-supply)
    )

) 

)