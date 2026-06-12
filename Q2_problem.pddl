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
    (thermal-reading room2 orange)
    (thermal-reading room3 yellow)
    (thermal-reading room4 green)
    (thermal-reading room5 red)

    (chemical-level-alive room1 low)    
    (chemical-level-alive room2 low)
    (chemical-level-alive room3 low)
    (chemical-level-alive room4 low)
    (chemical-level-alive room5 high)

    (chemical-level-deceased room1 low)
    (chemical-level-deceased room2 low)
    (chemical-level-deceased room3 high)
    (chemical-level-deceased room4 low)
    (chemical-level-deceased room5 low)


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