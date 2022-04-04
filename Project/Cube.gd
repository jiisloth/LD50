extends RigidBody

func _process(delta):
    if transform.origin.y < -4:
        queue_free()
    if transform.origin.y < 0:
        if not $AudioStreamPlayer3D.playing:
            $AudioStreamPlayer3D.play(randf()*30.0)
            linear_damp = 10.0
            angular_damp = 5.0
            $Particles.emitting = true
            $Particles2.emitting = true
