(define (domain victim-monitor)

(:requirements :strips :typing :equality :negative-preconditions :disjunctive-preconditions :fluents :time)

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
    no yes - obstacle
)

(:predicates 
    (robot-at ?loc - location)
    (victim-found ?loc - location) 
    (victim-alive ?loc - location)
    (victim-deceased ?loc - location)
    (remap)
    (victim-vitals)
    (all-data-sent)
    (abort-mission)
    (failure)
    (connected ?loc1 ?loc2 - location)
    (thermal-reading ?loc - location ?reading - thermal-signature)
    (chemical-level-alive ?loc - location ?co2 - CO2-level)
    (chemical-level-deceased ?loc - location ?ammonia - ammonia-level)
    (cleared-room ?loc - location) 
    (visibility ?loc - location ?vis - visibility-level)
    (noise-level ?loc - location ?level - dB-level)
    (signal-connection ?loc - location ?signal - signal-level)
    (obstacle-detection ?loc - location ?obs - obstacle)
)

(:functions
    (battery-level)
    (victim-health)
    (rescue)
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

(:process victim-health-background
    :parameters ()
    :precondition (not (victim-vitals))
    :effect (decrease (victim-health) (* #t 10))   
)

(:process rescue-time
    :parameters ()
    :precondition (not(all-data-sent))
    :effect (decrease(rescue)(* #t 1))
 )


(:event victim-health-depletion
    :parameters ()
    :precondition (< (victim-health) 0)
    :effect (abort-mission)
)

(:event time-constraint
    :parameters ()
    :precondition (< (rescue)3600)
    :effect(abort-mission)
)


(:event battery-life
    :parameters ()
    :precondition (< (battery-level) 15)
    :effect (abort-mission)
)

(:durative-action move 
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and 
        (over all (not (abort-mission)))
        (at start (robot-at ?from))
        (over all (connected ?from ?to))
        (at start (cleared-room ?from))
        (over all (>= (battery-level)20))
        
    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at end (robot-at ?to))
        (at end (decrease (battery-level) 10))
         
    )
)

(:action send-distress-signal
    :parameters (?loc - location ?signal - signal-level)
    :precondition (and
        (victim-vitals) 
        (or (remap) (abort-mission))
        (robot-at ?loc)
        (signal-connection ?loc ?signal)
        (= ?signal strong)
    )
    :effect (and
        (all-data-sent)
    )
) 

(:durative-action move-to-signal
    :parameters (?from ?to - location )
    :duration (= ?duration 5)
    :condition (and
       (at start (robot-at ?from))
       (over all (connected ?from ?to))
       (at start (or (remap) (abort-mission)))
       (at start (>=(battery-level)20))

    )
    :effect(and 
        (at start (not (robot-at ?from)))
        (at end (robot-at ?to))
        (at end (decrease (battery-level)10))
        
    )

)


(:event obstacle
    :parameters (?loc - location ?obs -obstacle)
    :precondition (and 
        (robot-at ?loc)
        (obstacle-detection ?loc ?obs)

        (= ?obs yes)
    )
    :effect (and 
        (abort-mission)
    
    )
)


)