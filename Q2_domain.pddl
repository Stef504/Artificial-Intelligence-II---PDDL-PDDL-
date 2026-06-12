(define (domain explore-building)

(:requirements :strips :typing :equality)

(:types 
    location
)

(:constants
    red orange yellow green blue - thermal-signature
    high medium low - CO2-level
    high medium low - ammonia-level
    probability1 probability2 probability3 probability4 probability5 - visibility-level
    lowdB 
)

(:predicates 
    (robot-at ?loc - location)
    (victim-found)
    (oxygen-supply)
    (connected ?loc1 ?loc2 - location)
    (thermal-reading ?loc - location ?reading - thermal-signature)
    (chemical-level ?loc - location ?level - CO2-level)
    (chemical-level-alive ?loc - location ?level - ammonia-level)
    (chemical-level-deceased ?loc - location ?level - ammonia-level)
    (cleared-room ?loc - location) 
    (visibility ?loc - location ?vis - visibility-level)
)

(:action scan 
    :parameters (?loc - location ?level - CO2-level ?reading - thermal-signature ?vis - visibility-level)
    :precondition (and
        (robot-at ?loc)
        (thermal-reading ?loc ?reading)
        (chemical-level ?loc ?level)
        (visibility ?loc ?vis)
    )

    :effect 
        (cleared-room ?loc)
    
)


(:action locate 
    :parameters (?loc - location ?reading - thermal-signature ?level - CO2-level ?vis - visibility-level)
    
    :precondition (and 
        (cleared-room ?loc)
        (robot-at ?loc)
        
        (thermal-reading ?loc ?reading)
        (chemical-level ?loc ?level)
        (visibility ?loc ?vis)
        (= ?reading red)
        (= ?level high)
        (= ?vis probability5)
    )
    :effect
        (victim-found)
    
)

(:action rescue
    :parameters (?loc - location)
    :precondition (and 
        (robot-at ?loc)
        (victim-found)
    )
    :effect(and 
        (oxygen-supply)
    )

)

(:action move 
    :parameters (?from ?to - location)
    :precondition (and 
        (cleared-room ?from)
        (robot-at ?from)
        (connected ?from ?to)
    )
    :effect(and 
        (not(robot-at ?from))
        (robot-at ?to)
        (not(cleared-room ?to))
         
)
)
)