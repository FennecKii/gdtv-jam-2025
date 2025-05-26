class_name SoundResource
extends Resource

enum SoundType {
	FART_1,
	FART_2,
	FART_3,
	GRAB,
	RELEASE_1,
	RELEASE_2,
	BUTTON_PRESS,
	BUTTON_HOVER,
	BUTTON_SCROLL,
	BUTTON_START,
	BUTTON_PANEL,
	GOLDEN_POOP
}

@export var type: SoundType
@export var sound: AudioStream
@export_range(-40, 20, 1) var volume: float = 0
@export_range(0.0, 4.0, 0.01) var pitch_scale: float = 1.0
@export_range(0.0, 4.0, 0.01) var pitch_randomness: float = 0
