extends KinematicBody2D

class_name Actor

export var speed = 120
export var gravity = 10

var velocity: = Vector2.ZERO
var is_dead = false

const FLOOR = Vector2(0, -1)

#func _physics_process(delta):
#	velocity.y += gravity * delta
#	velocity = move_and_slide(velocity)
