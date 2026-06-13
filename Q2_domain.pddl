(define (domain explore-building)

(:requirements :strips :typing :equality :negative-preconditions :disjunctive-preconditions :fluents :durative-actions)

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

(:durative-action scan-victim 
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level )
    :duration (= ?duration 3)
    :condition (and
        
        (at start (thermal-reading ?loc ?reading))
        (at start (visibility ?loc ?vis))
        (at start (noise-level ?loc ?level))

        (over all (>= (battery-level) 10))
        (over all (robot-at ?loc))
    )

    :effect (and 
        (at end (cleared-room ?loc))
        (at end (decrease (battery-level) 4))
    )
    
)

(:durative-action locate-victim
    :parameters (?loc - location  )
    :duration (= ?duration 1)
    :condition (and
        (over all (cleared-room ?loc))
        (over all (robot-at ?loc))
        
        (at start (thermal-reading ?loc red))
        (at start (visibility ?loc probability5))
        (at start (noise-level ?loc highdB))

    )
    :effect (and 
        (at end (victim-found ?loc))
        (at end (remap))
    )
)

(:durative-action victim-health-check-alive
    :parameters (?loc - location  )
    :duration (= ?duration 1)
    :condition (and 
        (over all (robot-at ?loc))
        (over all (victim-found ?loc))

        (at start (chemical-level-alive ?loc high))
    )
    :effect(and
        (at end (victim-alive ?loc))
        (at end (victim-vitals))
    )
)

(:durative-action victim-health-check-deceased
    :parameters (?loc - location )
    :duration (= ?duration 1)
    :condition (and 
        (over all (robot-at ?loc))
        (over all (victim-found ?loc))

        (at start (chemical-level-deceased ?loc high1))
    )

    :effect(and 
        (at end (victim-deceased ?loc))
        (at end (victim-vitals))
    )
)

(:durative-action move 
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot-at ?from))
        (at start (connected ?from ?to))
        (at start (not (remap)))
        (at start (cleared-room ?from))  
        
        (over all (>= (battery-level) 10))
        
    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at end (robot-at ?to))
        (at end (decrease (battery-level) 10))
         
    )
)

(:durative-action send-distress-signal
    :parameters (?loc - location )
    :duration (= ?duration 1)
    :condition (and
        (over all (victim-vitals))
        (over all (remap))
        (over all (robot-at ?loc))

        (at start (signal-connection ?loc strong))

    )
    :effect (and
       (at end (all-data-sent))
    )
)

(:durative-action move-to-signal
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and
        (at start (robot-at ?from))
        (at start (connected ?from ?to))
        (at start (remap))

        (over all (>= (battery-level) 10))

    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at end (robot-at ?to))
        (at end (decrease (battery-level) 10))
        
    )

)

)