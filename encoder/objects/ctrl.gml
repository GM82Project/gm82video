#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (parameter_count()) {
    fn=parameter_string(1)
    if (string_pos(".rv2",fn)) {
        instance_create(0,0,player)
        player.vid=video_play(fn)
    } else {
        encode(fn,filename_change_ext(fn,".rv2"))
        game_end()
    }
} else {
    instance_create(0,0,player)
    player.vid=video_play("hotel mario opening.rv2",1)
}
