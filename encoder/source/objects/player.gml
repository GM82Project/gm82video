#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
spd=1
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (!video_isplaying(vid)) {video_destroy(vid) instance_destroy()}
#define Mouse_53
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
video_reset(vid)
#define Mouse_54
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
video_destroy(vid) instance_destroy()
#define Mouse_60
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
spd=min(4,spd+0.25)
video_set_speed(vid,spd)
#define Mouse_61
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
spd=max(0.25,spd-0.25)
video_set_speed(vid,spd)
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
w=video_get_width(vid)
h=video_get_height(vid)

s=min(800/w,608/h)

texture_set_interpolation(1)
video_draw(vid,0,0,w*s,h*s)
