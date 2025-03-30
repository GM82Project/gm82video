with (File) {
    fn=argument0
    if (fn!="") {
        name=fn
        with (Previewer) if (vid) {video_destroy(vid) vid=noone}
        with (Encoder) encode(File.name,"",0)
    }
}
