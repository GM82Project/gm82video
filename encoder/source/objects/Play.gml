#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
sel=0
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
sel=1
#define Mouse_7
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (sel && Encoder.encoded) if (file_exists(Encoder.output)) {
    with (Previewer) {
        if (vid) video_reset(vid)
        else {
            vid=video_play(Encoder.output)
            str=string(video_get_width(vid))+"x"+string(video_get_height(vid))+" - "+string(video_get_fps(vid))+" fps - "
        }
    }
}
sel=0
#define Mouse_11
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
sel=0
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
if (!Encoder.encoded) draw_set_color($808080)
draw_text(x,y,"Test")
draw_set_color($ffffff)
