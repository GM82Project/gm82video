with (Player) {
    mute=!mute
    other.image=4+mute
    if (video) video_set_volume(video,!mute)
}
