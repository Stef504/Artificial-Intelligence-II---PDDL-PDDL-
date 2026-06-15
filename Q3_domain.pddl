(define (domain victim-monitor)

(:requirements :strips :typing :equality :negative-preconditions :disjunctive-preconditions :fluents :time )

(:types 
    location
    thermal-signature
    CO2-level
    ammonia-level
    visibility-level
    dB-level
    signal-level
    obstacle
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
    (victim-alive )
    (victim-deceased )
    (remap)
    (victim-vitals)
    (all-data-sent)
    (abort-mission)
    (phase-scan)
    (phase-move)
    (moving)
    (scanning)
    (search-signal)
    (failure) 
    (victim-located)
    (connected ?loc1 ?loc2 - location)
    (thermal-reading ?loc - location ?reading - thermal-signature)
    (chemical-level-alive ?loc - location ?co2 - CO2-level)
    (chemical-level-deceased ?loc - location ?ammonia - ammonia-level)
    (cleared-room ?loc - location) 
    (visibility ?loc - location ?vis - visibility-level)
    (noise-level ?loc - location ?level - dB-level)
    (signal-connection ?loc - location ?signal - signal-level)
    (obstacle-detection ?loc - location ?obs - obstacle)
    (scanning-at ?loc - location)
    (moving-to ?loc - location)
)

(:functions
    (battery-level)
    (victim-health)
    (rescue)
    (robot-scan)
    (robot-move)
    (robot-signal)

)


;SCANNING

(:action start-scan 
    :parameters (?loc - location  ?reading - thermal-signature ?vis - visibility-level ?level - dB-level )
    :precondition (and
        (phase-scan)
        (thermal-reading ?loc ?reading)
        (visibility ?loc ?vis)
        (noise-level ?loc ?level)
        (robot-at ?loc)

        (not (abort-mission))
        (not (phase-move))
        (not (scanning))

        (>= (battery-level) 10)
    )

    :effect (and
        (scanning)
        (scanning-at ?loc)
        (assign (robot-scan) 10)
    )
    
)

(:process scanning-in-progress
    :parameters ()
    :precondition (scanning)
    :effect (decrease (robot-scan)(* #t 1))
)

(:action end-scan
    :parameters (?loc - location)
    :precondition (and 
        (scanning)
        (scanning-at ?loc)
        (<= (robot-scan) 0)
    )
    :effect (and 
        (not (phase-scan))
        (not(scanning))
        (not (scanning-at ?loc))

        (cleared-room ?loc)
        (phase-move)

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

        (not (abort-mission))

    )
    :effect (and 
        (victim-found ?loc)
        (victim-located)
        (remap)
    )
)

(:action victim-health-check-alive
    :parameters (?loc - location )
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-alive ?loc high)
        (not (abort-mission))

    )
    :effect(and
        (victim-alive )
        (victim-vitals)
  
    )
)

(:action victim-health-check-deceased
    :parameters (?loc - location )
    :precondition (and 
        (robot-at ?loc)
        (victim-found ?loc)

        (chemical-level-deceased ?loc high1)
        (not (abort-mission))
    )
    :effect(and 
        (victim-deceased )
        (victim-vitals)
        
    )
)

(:process victim-health-background
    :parameters ()
    :precondition (and 
        (not (all-data-sent))
        (victim-alive)
        (victim-located)
    )
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
        (< (battery-level) 10)
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



(:action start-move 
    :parameters (?from ?to - location )
    :precondition (and 
        (phase-move)
        (connected ?from ?to)
        (robot-at ?from)
        (cleared-room ?from)

        (>= (battery-level) 20)

        (not (abort-mission))
        (not (phase-scan))
        (not (moving))
        (not (search-signal))
    )
    :effect(and 
        (not (robot-at ?from))

        (moving)
        (moving-to ?to)
        (assign (robot-move) 10)
    )
)

(:process move-in-progress
    :parameters()
    :precondition (moving)
    :effect (and 
        (decrease (robot-move) (* #t 1))
    )
)

(:action end-move
    :parameters (?to - location)
    :precondition (and 
        (moving)
        (moving-to ?to)
        (<= (robot-move) 0)
    )
    :effect (and 
        (not (moving))
        (not (phase-move))
        (not (moving-to ?to))

        (robot-at ?to)
        (decrease (battery-level) 10)
        (phase-scan)
    )
)


(:action start-move-to-signal
    :parameters (?from ?to - location )
    :precondition (and
        (robot-at ?from)
        (connected ?from ?to)
        (or (remap) (abort-mission))
        (not (moving))
        (not (search-signal))
        (>= (battery-level) 20)

    )
    :effect(and 
        (not (robot-at ?from))

        (search-signal)
        (moving-to ?to)
        (assign (robot-signal) 10)
    )
)

(:process moving-signal
    :parameters ()
    :precondition (search-signal)
    :effect (and 
        (decrease (robot-signal) (* #t 1))
    )
)

(:action found-signal
    :parameters (?to - location)
    :precondition (and 
        (search-signal)
        (moving-to ?to)
        (<= (robot-signal) 0)
    )
    :effect (and 
        (not(search-signal))
        (not (moving-to ?to))

        (robot-at ?to)
        (decrease (battery-level) 10)
    )
)

;SEND DATA

(:action send-distress-signal
    :parameters (?loc - location )
    :precondition (and
        (victim-vitals)
        (or (remap) (abort-mission))
        (not (all-data-sent))
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
        (not (failure))
        (signal-connection ?loc strong)
        
    )
    :effect (and
        (failure)
        (all-data-sent)
    )
)



)