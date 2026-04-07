(define (domain minecraft)
  (:requirements :typing)

  (:types
    location                            ; Position in 3D space
    block                               ; Block, that can be manipulated with
  )

  (:predicates
    (at-robot ?l - location)            ; Robot position
    (at-block ?b - block ?l - location) ; Block position
    (clear ?l - location)               ; If position is empty
    (handempty)                         ; If robot has free hands
    (holding ?b - block)                ; Which block robot holds
    (adjacent ?l1 ?l2 - location)       ; If two block are adjacent
  )

  (:action move
    :parameters (?from ?to - location)
    :precondition (and
      (at-robot ?from)
      (adjacent ?from ?to)
      (clear ?to)
    )
    :effect (and
      (not (at-robot ?from))
      (at-robot ?to)
    )
  )

  (:action pick-up
    :parameters (?b - block ?bloc - location ?rloc - location)
    :precondition(and
      (handempty)
      (at-robot ?rloc)
      (at-block ?b ?bloc)
      (adjacent ?rlock ?bloc)
    )
    :effect(and
      (not (handempty))
      (holding ?b)
      (not (at-block ?b ?bloc))
      (clear ?bloc)
    )
  )

  (:action put-down
    :parameters(?b - location ?bloc - location ?rloc - location)
    :precondition(and
      (holding ?b)
      (at-robor ?rloc)
      (adjacent ?rloc ?bloc)
      (clear ?bloc)
    )
    :effect(and
      (not (holding ?b))
      (handempty)
      (at-block ?b ?bloc)
      (not (clear ?bloc))
    )
  )
)
