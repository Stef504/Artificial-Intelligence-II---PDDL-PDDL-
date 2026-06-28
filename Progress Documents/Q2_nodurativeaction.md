(define (domain explore-building)

(:requirements :strips :typing :equality :negative-preconditions :disjunctive-preconditions :fluents)

(:types 
    location
)

(:constants
    red orange yellow green blue - thermal-signature
    high medium low - CO2-level
    high1 medium1 low1 - ammonia-level
    probability1 probability2 probability3 probability4 probability5 - visibility-level
    lowdB highdB - dB-level
    poor strong - signal-level
)

(:predicates 
    (robot-at ?loc - location)
    (victim-found ?loc - location) 
    (victim-alive ?loc - location)
    (victim-deceased ?loc - location)
    (remap)
    (victim-vitals)
    (all-data-sent)
    (connected ?loc1 ?loc2 - location)
    (thermal-reading ?loc - location ?reading - thermal-signature)
    (chemical-level-alive ?loc - location ?co2 - CO2-level)
    (chemical-level-deceased ?loc - location ?ammonia - ammonia-level)
    (cleared-room ?loc - location) 
    (visibility ?loc - location ?vis - visibility-level)
    (noise-level ?loc - location ?level - dB-level)
    (signal-connection ?loc - location ?signal - signal-level)
)

(:functions
    (battery-level)
)

(:action scan-victim 
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level )
    :precondition (and
        (robot-at ?loc)
        (thermal-reading ?loc ?reading)
        (visibility ?loc ?vis)
        (noise-level ?loc ?level)
        (>=(battery-level)10)
    )

    :effect (and
        (cleared-room ?loc)
        (decrease (battery-level)5)
    )
    
)

(:action locate-victim
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level)
    :precondition (and
        (cleared-room ?loc)
        (robot-at ?loc)
        (thermal-reading ?loc ?reading)
        (visibility ?loc ?vis)
        (noise-level ?loc ?level)

        (= ?reading red)
        (= ?vis probability5)
        (= ?level highdB)
    )
    :effect (and 
        (victim-found ?loc)
        (remap)
    )
)

(:action victim-health-check-alive
    :parameters (?loc - location ?co2 - CO2-level )
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-alive ?loc ?co2)

        (= ?co2 high))
    :effect(and
        (victim-alive ?loc)
        (victim-vitals)
    )
)

(:action victim-health-check-deceased
    :parameters (?loc - location ?ammonia - ammonia-level)
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-deceased ?loc ?ammonia)

        (= ?ammonia high1))
    :effect(and 
        (victim-deceased ?loc)
        (victim-vitals)
    )
)

(:action move 
    :parameters (?from ?to - location )
    :precondition (and 
        (robot-at ?from)
        (connected ?from ?to)
        (cleared-room ?from)
        (>= (battery-level)10)
        
    )
    :effect(and 
        (not (robot-at ?from))
        (robot-at ?to)
        (decrease (battery-level) 10)
         
    )
)

(:action send-distress-signal
    :parameters (?loc - location ?signal - signal-level)
    :precondition (and
        (victim-vitals)
        (remap)
        (robot-at ?loc)
        (signal-connection ?loc ?signal)
        (= ?signal strong)
    )
    :effect (and
        (all-data-sent)
    )
)

(:action move-to-signal
    :parameters (?from ?to - location )
    :precondition (and
       (robot-at ?from)
       (connected ?from ?to)
       (remap)
       (>=(battery-level)10)

    )
    :effect(and 
        (not (robot-at ?from))
        (robot-at ?to)
        (decrease (battery-level)10)
        
    )

)

)


## Problem 
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
    
    (= (battery-level) 100)

)

(:goal(and
    (victim-vitals)
    (all-data-sent)
    
    )

) 

)


durative:

(:durative-action move-to-signal
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and
        (at start (robot-idle))
        (at start (robot-at ?from))
        (at start (remap))

       (over all (>= (battery-level) 20))
       (over all (connected ?from ?to))

    )
    :effect(and 
        (at start (not(robot-idle)))
        (at start (not (robot-at ?from)))
            
        (at end  (robot-idle))
        (at end  (robot-at ?to))
        (at end  (decrease (battery-level) 10))     
        
    )

)