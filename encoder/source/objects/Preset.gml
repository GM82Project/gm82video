#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
Scaling.scaling=scaling
Abitrate.bitrate=abitrate
Delta.delta=delta
Keyframe.keyframe=keyframe
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//field name: string
//field scaling
//field abitrate
//field delta
//field keyframe

/*preview
    draw_set_font(Font("Font"))
    draw_text(x,y,Field("name"))
*/
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
draw_text(x,y,name)
