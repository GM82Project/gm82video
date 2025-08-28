with (Player) if (video) {
    if (!video_isplaying(video)) video_reset(video)
    video_set_pause(video,0)
    video_set_speed(video,1)
}
