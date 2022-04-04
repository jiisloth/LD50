extends KinematicBody

var speed = 12
var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 12
var full_contact = false

var mouse_sensitivity = 0.10

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck
onready var raycast = $Head/Camera/RayCast

var orb_value = 0
var coyote = 10
var dead = false
var bunnyboost = 0
var time_on_ground = 0

func orb_get():
    orb_value -= 1
    $OrbGet.pitch_scale = 0.7+randf()*0.2
    $OrbGet.play()
    orb_value = 0

func _process(delta):
    orb_value += delta*0.07
    if transform.origin.y < -3:
        dead = true

func _ready():
    mouse_sensitivity = Global.sens
    $Head/Camera.fov = Global.fov
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
        head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
        head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
    elif event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed == true:
        var raycastHit = raycast.get_collider()
        if not raycastHit == null:
            if raycastHit.is_in_group("Moveable"):
                (raycastHit as RigidBody).apply_central_impulse(-raycast.get_global_transform().basis.z * 15)
            

func _physics_process(delta):
    coyote += delta
    time_on_ground += delta
    if time_on_ground > 0.15:
        bunnyboost = 0
    direction = Vector3()

    full_contact = ground_check.is_colliding()

    if not is_on_floor():
        gravity_vec += Vector3.DOWN * gravity * delta
        h_acceleration = air_acceleration
        time_on_ground = 0
    elif is_on_floor() and full_contact:
        if coyote > 0.2:
            $Land.pitch_scale = 0.5+randf()*0.4
            $Land.volume_db = min(-15, coyote*10-40)
            $Land.play()
        coyote = 0
        gravity_vec = -get_floor_normal() * gravity
        h_acceleration = normal_acceleration
    else:
        if coyote > 0.2:
            $Land.pitch_scale = 0.5+randf()*0.4
            $Land.volume_db = min(-15, coyote*10-40)
            $Land.play()
        coyote = 0
        gravity_vec = -get_floor_normal()
        h_acceleration = normal_acceleration

    var current_jump = max(jump-orb_value,5)
    if Input.is_action_just_pressed("jump") and (coyote < 0.3 or is_on_floor() or ground_check.is_colliding()):
        coyote = 1
        $Jump.pitch_scale = 0.8+randf()*0.2
        $Jump.play()
        if time_on_ground < 0.1:
            bunnyboost += 1
        gravity_vec = Vector3.UP * current_jump

    if Input.is_action_pressed("forward"):
        direction -= transform.basis.z
    elif Input.is_action_pressed("backward"):
        direction += transform.basis.z
    if Input.is_action_pressed("strafe_left"):
        direction -= transform.basis.x
    elif Input.is_action_pressed("strafe_right"):
        direction += transform.basis.x
        
            
    

    if not Input.is_action_pressed("forward"):
        bunnyboost = 0
    var current_speed = max(speed-orb_value+bunnyboost*0.3,5)
    direction = direction.normalized()
    
    h_velocity = h_velocity.linear_interpolate(direction * current_speed, h_acceleration * delta)
    movement.z = h_velocity.z + gravity_vec.z
    movement.x = h_velocity.x + gravity_vec.x
    movement.y = gravity_vec.y

    move_and_slide(movement, Vector3.UP)
