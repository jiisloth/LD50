extends RigidBody


func _process(delta):
    if transform.origin.y < -2:
        queue_free()
