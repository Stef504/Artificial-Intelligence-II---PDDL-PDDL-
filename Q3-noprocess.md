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
        (decrease (victim-health)10)
        (decrease (rescue)900)
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
        (decrease (victim-health)10)
        (decrease (rescue)900)
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
        (decrease (rescue)600)
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
        (decrease (rescue)600)
        
    )
)


(:event victim-health-depletion
    :parameters ()
    :precondition (> (victim-health) 0)
    :effect (abort-mission)
)

(:event time-constraint
    :parameters ()
    :precondition (> (rescue) 0)
    :effect(abort-mission)
)


(:event battery-life
    :parameters ()
    :precondition (< (battery-level) 15)
    :effect (abort-mission)
)

(:action move 
    :parameters (?from ?to - location )
    :precondition (and 
        (not (abort-mission))
        (robot-at ?from)
        (connected ?from ?to)
        (cleared-room ?from)
        (>= (battery-level)20)
        
    )
    :effect(and 
        (not (robot-at ?from))
        (robot-at ?to)
        (decrease (battery-level) 10)
        (decrease (victim-health)10)
        (decrease (rescue)900)
         
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

(:action move-to-signal
    :parameters (?from ?to - location )
    :precondition (and
       (robot-at ?from)
       (connected ?from ?to)
       (or (remap) (abort-mission))
       (>=(battery-level)20)

    )
    :effect(and 
        (not (robot-at ?from))
        (robot-at ?to)
        (decrease (battery-level)10)
        (decrease (victim-health)10)
        (decrease (rescue)900)
        
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
