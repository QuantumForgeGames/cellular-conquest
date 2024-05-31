
extends Node

signal spawn_root_attached

const SPAWN_DISTANCE = 750.0
const SHIFT_DISTANCE = 150.0

@export var _enemy_data :Array[EnemyData] = []

var _enemies :Dictionary = {} 

var SpawnRoot :Node2D :
    set(value): 
        SpawnRoot = value
        spawn_root_attached.emit()

var player = null


func _ready () -> void:
    randomize()
    await spawn_root_attached

    var i = 0
    for data in _enemy_data:
        _enemies[i] = {
            instances = []
        }
        for n in range(data.max_count):
            _spawn_enemy(data, i)
        i += 1


func _find_enemy_spawn_location () -> Vector2:
    if not player: return Vector2.ZERO

    var new_position := Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * SPAWN_DISTANCE
    new_position = player.global_position + new_position
    for enemy_type in _enemies.values(): for enemy in enemy_type.instances:
        var direction = enemy.global_position - new_position
        if direction.length() > SHIFT_DISTANCE: continue
        new_position = new_position + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * SHIFT_DISTANCE
    
    return new_position


func _spawn_enemy (enemy_data :EnemyData, index :int) -> void:
    var enemy = enemy_data.scene.instantiate()
    enemy.global_position = _find_enemy_spawn_location()
    enemy.died.connect(_on_enemy_died.bind(enemy_data))
    enemy.died.connect(EventManager.on_enemy_died.bind(enemy.name))
    _enemies[index].instances.append(enemy)
    SpawnRoot.add_child(enemy)


func _on_enemy_died (enemy, enemy_data :EnemyData) -> void:
    var i = _enemy_data.find(enemy_data)
    if not _enemies.has(i): return
    _enemies[i].instances.erase(enemy)
    _spawn_enemy(enemy_data, i)

