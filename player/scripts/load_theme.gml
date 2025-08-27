var dir,theme;

dir="SOFTWARE\Game Maker\Version 8.2\Preferences\"
theme=registry_read_dword(dir+"GM82CustomThemeIndex",0)

if (theme==0) {
    global.col_low=$203020
    global.col_main=$404040
    global.col_high=$607060
    global.col_text=$ffffff
}
if (theme==1) {
    global.col_low=$808080
    global.col_main=$c0c0c0
    global.col_high=$ffffff
    global.col_text=$000000
}
if (theme==2) {
    global.col_low=registry_read_dword(dir+"GM82CustomThemeColorLow",$203020)
    global.col_main=registry_read_dword(dir+"GM82CustomThemeColorMain",$404040)
    global.col_high=registry_read_dword(dir+"GM82CustomThemeColorHigh",$607060)
    global.col_text=registry_read_dword(dir+"GM82CustomThemeColorText",$ffffff)
}

if (theme==0) {
    global.col_low=$203020
    global.col_main=$404040
    global.col_high=$607060
    global.col_text=$ffffff
    global.buttontex=sprButton0
    message_button(sprButton0)
}
if (theme==1) {
    global.col_low=$808080
    global.col_main=$c0c0c0
    global.col_high=$ffffff
    global.col_text=$000000
    global.buttontex=sprButton1
    message_button(sprButton1)
}

if (theme==2) {
    a=sprButtonWhitemask
    if (themebutton=1 || themebutton=2) a=sprButtonWhitemaskSmooth
    s=surface_create(80,25)
    surface_set_target(s)
    draw_clear(global.col_main)
    draw_sprite_ext(a,0,0,0,1,1,0,global.col_high,1)
    draw_sprite_ext(a,1,0,0,1,1,0,global.col_low,1)
    if (themebutton=2) draw_rectangle_color(0,0,79,24,global.col_text,global.col_text,global.col_text,global.col_text,1)
    spr=sprite_create_from_surface(s,0,0,80,25,0,0,0,0)
    sprite_add_from_surface(spr,s,0,0,80,25,0,0)
    draw_clear(global.col_main)
    draw_sprite_ext(a,0,0,0,1,1,0,global.col_low,1)
    draw_sprite_ext(a,1,0,0,1,1,0,global.col_high,1)
    if (themebutton=2) draw_rectangle_color(0,0,79,24,global.col_text,global.col_text,global.col_text,global.col_text,1)
    sprite_add_from_surface(spr,s,0,0,80,25,0,0)
    surface_reset_target()
    surface_free(s)
    sprite_assign(sprButton,spr)
    message_button(sprButton)
    global.buttontex=sprButton
}

background_assign(bgMessage,background_create_color(1,1,global.col_main))
message_background(bgMessage)
message_text_font("Courier New",12,global.col_text,1)
message_button_font("Courier New",12,global.col_text,1)
message_input_font("Courier New",12,global.col_text,1)
message_mouse_color(global.col_text)
