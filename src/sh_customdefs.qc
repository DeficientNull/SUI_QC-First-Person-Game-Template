//shared definitions

#define printf(x, ...) print(sprintf(x, __VA_ARGS__))


void() precache_everything =
{
	precache_sound("demon/dland2.wav");
	precache_model("models/testplayer.iqm");

	// func_button sounds
	precache_sound("buttons/airbut1.wav");
	precache_sound("buttons/switch21.wav");
	precache_sound("buttons/switch02.wav");
	precache_sound("buttons/switch04.wav");
};

const float EVENT_FADEIN = 1;
const float EVENT_FADEOUT = 2;
/*
enum :int {
	EVENT_FADEIN,
	EVENT_FADEOUT
}; */ 
