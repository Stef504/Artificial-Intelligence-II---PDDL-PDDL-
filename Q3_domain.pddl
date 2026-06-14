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
    :parameters (?loc - location )
    :precondition (and
        (cleared-room ?loc)
        (robot-at ?loc)
        (thermal-reading ?loc red)
        (visibility ?loc probability5)
        (noise-level ?loc highdB)

    )
    :effect (and 
        (victim-found ?loc)
        (remap)
    )
)

(:action victim-health-check-alive
    :parameters (?loc - location )
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-alive ?loc high)

    )
    :effect(and
        (victim-alive ?loc)
        (victim-vitals)
    )
)

(:action victim-health-check-deceased
    :parameters (?loc - location )
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-deceased ?loc high1)
    )
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
    :precondition (and 
        (not(abort-mission))
        (< (victim-health) 0)
    )
    :effect (abort-mission)
)

(:event time-constraint
    :parameters ()
    :precondition (and 
        (not(abort-mission))
        (< (rescue) 0)
    )
    :effect(abort-mission)
)


(:event battery-life
    :parameters ()
    :precondition (and
        (not(abort-mission))
        (< (battery-level) 15)
    )
    :effect (abort-mission)
)


(:event obstacle
    :parameters (?loc - location )
    :precondition (and 
        (not(abort-mission))
        (robot-at ?loc)
        (obstacle-detection ?loc yes)
    )
    :effect (and 
        (abort-mission)
    
    )
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
         
    )
)

(:action send-distress-signal
    :parameters (?loc - location )
    :precondition (and
        (victim-vitals)
        (remap)
        (robot-at ?loc)
        (signal-connection ?loc strong)
    )
    :effect (and
        (all-data-sent)
    )
) 

(:action send-abort
    :parameters (?loc - location ) 
    :precondition (and 
        (abort-mission)
        (robot-at ?loc)
        (signal-connection ?loc strong)
        
    )
    :effect (and
        (failure)
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
        
    )

)




)