(define (domain locate-victim)

(:requirements :strips :typing :equality :negative-preconditions)

(:types
    location
)

(:constants 
    red orange yellow green blue - thermal-signature
    probability1 probability2 probability3 probability4 probability5 - visibility-level
    lowdB highdB - dB-level
)

(:predicates
    (robot-at ?loc - location)
    (victim-at ?loc - location)
    (victim-found)
    (oxygen-supply)
    (scan)
    (connected ?loc1 ?loc2 - location)
    (visibility ?loc - location ?vis - visibility-level)
    (noise-level ?loc - location ?level - dB-level)
    (thermal-reading ?loc - location ?reading - thermal-signature)
)

(:action move 
    :parameters (?from ?to - location)
    :precondition (and 
        (robot-at ?from)
        (connected ?from ?to)
    )
    :effect(and 
        (not(robot-at ?from))
        (robot-at ?to)
        (scan)
)
)


(:action scan-victim
    :parameters (?loc - location )
    :precondition (and
        (robot-at ?loc)
        (thermal-reading ?loc red)
        (visibility ?loc probability5)
        (noise-level ?loc highdB)
        (scan)
    )
    :effect (and 
        (victim-found)
    )
)

(:action rescue
    :parameters (?loc - location)
    :precondition (and 
        (robot-at ?loc)
        (victim-at ?loc)
        (victim-found)
    )
    :effect(and 
        (oxygen-supply)
    )

)
)