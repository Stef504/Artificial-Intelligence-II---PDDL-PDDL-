(define (domain locate-victim)

(:requirements :strips :typing)

(:types
    location
)

(:predicates
    (robot-at ?loc - location)
    (victim-at ?loc - location)
    (victim-found)
    (oxygen-supply)
    (connected ?loc1 ?loc2 - location)
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
)
)

(:action locate 
    :parameters (?loc - location)
    :precondition (and 
        (robot-at ?loc)
        (victim-at ?loc)
    )
    :effect(and 
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