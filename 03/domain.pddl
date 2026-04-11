(define (domain minecraft)
  (:requirements :typing)

  (:types
    location                            ; Position in 3D space
    block                               ; Block, that can be manipulated with
  )

  (:predicates
    (at-robot ?l - location)            ; Robot position
    (at-block ?b - block ?l - location) ; Block position
    (on ?top - block ?bottom - block)   ; Top is on the Bottom (Removed comma here)
    (on-ground ?b - block)              ; The block `b` is on the ground
    (free-ground ?l - location)         ; Ground at `l` does not have a block there
    (clear ?b - block)                  ; No block above block `b`
    (handempty)                         ; If robot has free hands
    (holding ?b - block)                ; Robot is holding block `b`
    (adjacent ?l1 ?l2 - location)       ; If two locations are adjacent
  )

  (:action move
    :parameters (?from ?to - location)  ; Move from `from` location to `to` location
    :precondition (and
      (at-robot ?from)                  ; Robot is at starting location `from`
      (adjacent ?from ?to)              ; `from` and `to` are adjacent
    )
    :effect (and
      (not (at-robot ?from))            ; Remove robot from `from`
      (at-robot ?to)                    ; Add robot to `to`
    )
  )

  (:action pick-up-from-ground
   :parameters (
      ?b - block                        ; Block to pick-up
      ?bloc - location                  ; Block location
      ?rloc - location                  ; Robot location
    )
    :precondition(and
      (at-robot ?rloc)                  ; Robot must be at robot location
      (at-block ?b ?bloc)               ; Block to pick-up must be at block location
      (adjacent ?rloc ?bloc)            ; Robot must be next to block to pick-up
      (clear ?b)                        ; Block to pick-up does not have anything above
      (on-ground ?b)                    ; Block to pick-up is on the ground
      (handempty)                       ; Robot must have empty hand to pick-up
    )
    :effect(and
      (not (at-block ?b ?bloc))         ; Block not at the location anymore
      (not (on-ground ?b))
      (not (clear ?b))
      (free-ground ?bloc)
      (not (handempty))                 ; Not empty hand anymore
      (holding ?b)                      ; Block `b` in hand
    )
  )

  (:action pick-up-from-block
   :parameters (
     ?top - block                       ; Block to pick-up (top one)
     ?bottom - block                    ; Block `bottom` the `top` one
     ?bloc - location                   ; Location of the stack
     ?rloc - location                   ; Robot location
   )
   :precondition(and
     (at-robot ?rloc)                   ; Robot must be at robot location
     (at-block ?top ?bloc)              ; `Top` block is where it should be
     (at-block ?bottom ?bloc)           ; `Bottom` block is where it should be
     (on ?top ?bottom)                  ; `Top` is on `bottom` block
     (adjacent ?rloc ?bloc)             ; Robot is next to the stack
     (clear ?top)                       ; Nothing is on `top` block
     (handempty)                        ; Robot must have empty hand to pick-up
   )
   :effect(and
     (not (at-block ?top ?bloc))        ; Fixed ?toploc to ?bloc
     (not (on ?top ?bottom))            ; `Top` is no longer on the `bottom`
     (not (clear ?top))
     (clear ?bottom)                    ; `Bottom` now does not block above
     (not (handempty))                  ; Not empty hand anymore
     (holding ?top)                     ; Fixed ?b to ?top
   )
  )

  (:action put-down-on-ground           ; Put a block on the ground
    :parameters(
      ?b - block                        ; Block to put-down
      ?bloc - location                  ; Where to put it
      ?rloc - location                  ; Robot location
    )
    :precondition(and
      (at-robot ?rloc)                  ; Robot is on the location
      (adjacent ?rloc ?bloc)            ; Robot is next to the location to put-down the block
      (free-ground ?bloc)
      (holding ?b)
    )
    :effect(and
      (at-block ?b ?bloc)
      (on-ground ?b)                    ; Added this back so the block registers as on the ground!
      (clear ?b)                        ; Fixed ?bloc to ?b (blocks are clear, not locations)
      (not (free-ground ?bloc))
      (not (holding ?b))
      (handempty)
    )
  )

  (:action put-down-on-block
   :parameters(
     ?top - block                       ; Block currently in hand
     ?bottom - block                    ; Block to place it on
     ?bloc - location                   ; Location of the target block
     ?rloc - location                   ; Robot location
    )
   :precondition(and
     (at-robot ?rloc)
     (at-block ?bottom ?bloc)           ; Target block is at this location
     (adjacent ?rloc ?bloc)             ; Robot is next to the target block
     (clear ?bottom)                    ; Target block has nothing on it
     (holding ?top)                     ; Robot is holding the top block
    )
   :effect(and
     (not (holding ?top))
     (handempty)
     (at-block ?top ?bloc)              ; The top block is now at this grid location
     (on ?top ?bottom)                  ; The top block is on the bottom block
     (clear ?top)                       ; The top block is now clear
     (not (clear ?bottom))              ; The bottom block is no longer clear
    )
  )
)
