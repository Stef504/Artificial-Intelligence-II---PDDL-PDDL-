(define(problem victim-monitor-1)

(:domain victim-monitor)

(:objects 
    room1 room2 room3 room4 room5 - location

)

(:init
    (connected room1 room2)
    (connected room2 room3)
    (connected room3 room4)
    (connected room4 room5)

    (connected room2 room1)
    (connected room3 room2)
    (connected room4 room3)
    (connected room5 room4)

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

    (chemical-level-deceased room1 low1)
    (chemical-level-deceased room2 low1)
    (chemical-level-deceased room3 low1)
    (chemical-level-deceased room4 low1)
    (chemical-level-deceased room5 low1)


    (visibility room1 probability1)
    (visibility room2 probability3)
    (visibility room3 probability2)
    (visibility room4 probability4)
    (visibility room5 probability5)

    (noise-level room1 lowdB)
    (noise-level room2 lowdB)
    (noise-level room3 lowdB)
    (noise-level room4 lowdB)
    (noise-level room5 highdB)

    (signal-connection room1 strong)
    (signal-connection room2 poor)
    (signal-connection room3 strong)
    (signal-connection room4 poor)
    (signal-connection room5 poor)

    (obstacle-detection room1 no)
    (obstacle-detection room2 no)
    (obstacle-detection room3 no)
    (obstacle-detection room4 no)
    (obstacle-detection room5 no)

    (phase-scan)

    
    (= (battery-level) 500)
    (= (victim-health) 500)
    (= (rescue) 3600)
    (= (robot-move) 10)
    (= (robot-scan) 10)
    (= (robot-signal) 10)


)

(:goal
    (all-data-sent)
)

) 

