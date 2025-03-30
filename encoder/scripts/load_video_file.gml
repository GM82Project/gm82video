with (File) {
    fn=argument0
    if (fn!="") {
        name=fn
        save_as=""
        with (Previewer) if (vid) {video_destroy(vid) vid=noone}
        with (Encoder) encode(File.name,"",0)
        Fps.vfps=Encoder.videofps
    }
}
