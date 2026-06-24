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
    (robot-idle)
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

(:durative-action scan
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level)
    :duration (= ?duration 2)
    :condition (and
        (at start (robot-at ?loc))
        (at start (thermal-reading ?loc ?reading))
        (at start (visibility ?loc ?vis))
        (at start (noise-level ?loc ?level))
        (at start (robot-idle))

        (over all (>=(battery-level)10))
    )
    :effect (and 
        (at start (robot-at ?loc))
        (at start (not (robot-idle)))

        (at end  (cleared-room ?loc))
        (at end (robot-idle))

        (at end  (decrease (battery-level)5))

    )
    
)


(:durative-action locate-victim
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level)
    :duration (= ?duration 1)
    :condition (and
        (at start (cleared-room ?loc))
        (over all (robot-at ?loc))
        (at start (robot-idle))
        (at start(thermal-reading ?loc ?reading))
        (at start(visibility ?loc ?vis))
        (at start(noise-level ?loc ?level))

        (at start(= ?reading red))
        (at start(= ?vis probability5))
        (at start(= ?level highdB))
    )
    :effect (and 
        (at start (not (robot-idle)))
        (at end (victim-found ?loc))
        (at end (remap))
        (at end (robot-idle))
    )
)

(:durative-action victim-health-check-alive
    :parameters (?loc - location ?co2 - CO2-level )
    :duration (= ?duration 1)
    :condition (and 
        (over all (robot-at ?loc))
        (at start (victim-found ?loc))
        (at start (robot-idle))

        (at start (chemical-level-alive ?loc ?co2))

        (at start (= ?co2 high))
        
    )
    :effect(and
        (at start (not (robot-idle)))

        (at end (victim-alive ?loc))
        (at end (victim-vitals))
        (at end (robot-idle))
    )
)

(:durative-action victim-health-check-deceased
    :parameters (?loc - location ?ammonia - ammonia-level)
    :duration (= ?duration 1)
    :condition (and 
        (over all (robot-at ?loc))
        (at start (victim-found ?loc))
        (at start (robot-idle))

        (at start (chemical-level-deceased ?loc ?ammonia))

        (at start (= ?ammonia high1)))
    :effect(and 
        (at start (not (robot-idle)))

        (at end (victim-deceased ?loc))
        (at end (victim-vitals))
        (at end (robot-idle))
    )
)

(:durative-action move 
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and 
        (at start (robot-at ?from))
        (at start (cleared-room ?from))
        (at start (robot-idle))
        (over all (>= (battery-level) 20))
        (over all  (connected ?from ?to))
               
    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at start (not(robot-idle)))

        (at end (decrease (battery-level) 10))
        (at end  (robot-at ?to))
        (at end (robot-idle))
    )
)

(:durative-action send-distress-signal
    :parameters (?loc - location ?signal - signal-level)
    :duration (= ?duration 1)
    :condition (and
        (at start (victim-vitals))
        (at start (remap))
        (at start (robot-idle))
        (over all (robot-at ?loc))
        (at start (signal-connection ?loc ?signal))
        (at start (= ?signal strong))
    )
    :effect (and
        (at start (not(robot-idle)))
        (at end  (all-data-sent))
        (at end (robot-idle))
    )
)


)