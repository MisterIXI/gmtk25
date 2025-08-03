extends Node3D
#
# SoundManager.playSound(SoundManager.SOUND.CLICK)
# SoundManager.playSound3D(SoundManager.SOUND.DROP_CRATE, global_position)
#
#
#
#
#
enum SOUND {
	# 2D Sounds
	MUSIC = 0,
	CLICK = 1,
	GAME_WIN = 2,
	#3D Sounds
	DROP_CRATE = 3,
	GATE_OPEN = 4,
	WIPER = 5
}

@onready var _audio3d_drop_crate : AudioStreamPlayer3D = $Stream3D_01
@onready var _audio3d_gate_open : AudioStreamPlayer3D = $Stream3D_02
@onready var _audio3d_wiper : AudioStreamPlayer3D = $Stream3D_03

@onready var _audio_music : AudioStreamPlayer = $Music
@onready var _audio_click : AudioStreamPlayer = $Click
@onready var _audio_game_win: AudioStreamPlayer = $Game_Win

func _ready() -> void:
	_audio_music.play()

func pause_music() ->void:
	_audio_music.stream_paused = true

func playSound(_sound : SOUND) ->void:
	match _sound:
		SOUND.MUSIC:
			_audio_music.stream_paused = false
			_audio_music.play()

		SOUND.CLICK:
			_audio_click.pitch_scale = randf_range(0.5, 1.5)
			_audio_click.play()
		
		SOUND.GAME_WIN:
			_audio_game_win.play()
		_:
			print("SoundManager Error: no match of SOUND")
func playSound3D(_sound : SOUND, _pos : Vector3) ->void:
	match _sound:
		SOUND.DROP_CRATE:
			_audio3d_drop_crate.global_position = _pos
			_audio3d_drop_crate.pitch_scale = randf_range(0.5, 1.5)
			_audio3d_drop_crate.play()
		SOUND.GATE_OPEN:
			_audio3d_gate_open.global_position = _pos
			_audio3d_gate_open.pitch_scale = randf_range(0.5, 1.5)
			_audio3d_gate_open.play()
		SOUND.WIPER:
			_audio3d_wiper.global_position = _pos
			_audio3d_wiper.pitch_scale = randf_range(0.8, 1)
			_audio3d_wiper.play()
		
		_:
			print("SoundManager Error: no match of SOUND3D")
func stop_wiper_sound() ->void:
	_audio3d_wiper.stop()