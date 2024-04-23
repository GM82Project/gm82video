#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=0
keyframe=20
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (grab) keyframe=round(lerp(0,100,saturate((mouse_x-x)/sprite_width)))
#define Mouse_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=1
#define Mouse_5
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
keyframe=20
#define Mouse_56
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
grab=0
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self()
l=keyframe/100*sprite_width

draw_line(x+l,y,x+l,y+31)
if (keyframe==0) draw_text(x,y,"Disabled")
else draw_text(x,y,keyframe)
