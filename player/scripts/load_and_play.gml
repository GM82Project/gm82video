video=video_play(argument0)
set_application_title(filename_name(argument0))
room_caption=filename_name(argument0)+" - Game Maker 8.2 Video Player"
if (video) {
    video_set_volume(video,!mute)
    window_set_size(max(640,video_get_width(video)),max(512,video_get_height(video)+64))
    restart=true
}
window_set_foreground()
