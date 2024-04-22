///encode(input,output)

//initialize some paths
output=argument1
path=working_directory+"\temp\"
directory_create(path)
framepath=path+"frames\"
directory_create(framepath)
audiopath=framepath+"audio.mp3"
ffmpeg='"'+global.ffmpeg+'" -hide_banner'
logf=path+"log.txt"

if (!file_exists(global.ffmpeg)) {
    show_message("Error: FFMPEG.EXE not found. Please refer to the user manual for further instructions.")
    show_info()
    exit
}

encoding=true
encoded=false
su=-1
render=-1
status=rmEncoder_AA5B4A99

scaling=Scaling.scaling
abitrate=Abitrate.bitrate
delta=Delta.delta
interval=Keyframe.keyframe

//find video information
status.str="Gathering information..." screen_redraw() io_handle()
bat=path+"getfps.bat"

//write and run bat script
f=file_text_open_write(bat)
file_text_write_string(f,ffmpeg+' -i %1 >"%~dp0\log.txt" 2>&1')
file_text_close(f)
execute_program_silent(bat+' "'+argument0+'"')
sleep(100)
file_delete(bat)

//get information out of ffmpeg
if (!file_exists(logf)) {
    show_message("Error: FFMPEG didn't produce a log file.")
    exit
}
str=file_text_read_all(logf,"")
file_delete(logf)

if (!string_pos("Input #0, ",str)) {
    ffmpeg_error("",str)
    exit
}

gifmode=!!string_pos("Video: gif,",str)

//get fps
p2=string_pos(" tbr,",str)
if (!p2) p2=string_pos(" fps,",str)
if (!p2) {
    ffmpeg_error("##Cannot find video tbr/fps.##",str)
    exit
}
p1=p2 do {p1-=1} until (string_char_at(str,p1)==" ")
videofps=real(string_copy(str,p1,p2-p1))
if (videofps<=0) {
    ffmpeg_error("##Detected fps is zero or negative: "+string(videofps)+"##",str)
    exit
}

//get dimensions
w=0
h=0
repeat (string_token_start(str,", ")) {
    look=string_token_next()
    state="num"
    p1=0 p2=string_length(look)
    do {p1+=1
        c=string_char_at(look,p1)
        if (state="num") {
            if (c=="x") state="x"
            else if (!string_pos(c,"0123456789")) p1=p2+1
        } else if (state="x") {
            if (string_pos(c,"0123456789")) state="num2"
            else p1=p2+1
        } else if (state="num2") {
            if (c==" ") {state="win" p2=p1}
            else if (!string_pos(c,"0123456789")) p1=p2+1
        }
    } until (p1>=p2)
    if (p1==p2) {
        string_token_start(string_copy(look,1,p2),"x")
        w=floor(real(string_token_next())*scaling)
        h=floor(real(string_token_next())*scaling)
        break
    }
}
if (w<5 || h<5) {
    ffmpeg_error("##Detected size is too small: "+string(w)+"x"+string(h)+"##",str)
    exit
}

//get duration
if (string_pos("Duration: N/A",str)) {
    duration=0
    free=disk_free()
    if (free<500*1024*1024) if (!show_question(
        "The encoding operation will take an unknown amount of space to run, but it looks like the "
        +filename_drive(working_directory)
        +" drive only has about "
        +string(free/1024/1024)
        +" MB available.##Would you still like to try regardless?"
    )) {
        status.str="Operation cancelled."
        exit
    }
} else {
    p1=string_pos("Duration: ",str)+10
    if (!p1) {
        ffmpeg_error("##Cannot find duration information.##",str)
        exit
    }
    p2=p1 do {p2+=1} until (string_char_at(str,p2)==",")
    string_token_start(string_copy(str,p1,p2-p1),":")
    hour=real(string_token_next())
    minute=real(string_token_next())
    second=real(string_token_next())
    duration=hour*3600+minute*60+second

    if (duration<0.05) {
        ffmpeg_error("##Detected duration is too short: "+string(duration)+"##",str)
        exit
    }
    //check disk space
    pngfactor=0.5 //fuck it. we ball
    space=duration*videofps*w*h*4*pngfactor
    free=disk_free()
    if (free<space*pngfactor) if (!show_question(
        "The encoding operation will take approximately "
        +string(space/1024/1024)
        +" MB on the "
        +filename_drive(working_directory)
        +" drive, but only "
        +string(free/1024/1024)
        +" MB is available.##Would you still like to try regardless?"
    )) {
        status.str="Operation cancelled."
        exit
    }
}

//extract frames and audio
status.str="Exporting frames..." screen_redraw() io_handle()
if (scaling!=1) option='-vf "scale=iw*'+string(scaling)+':ih*'+string(scaling)+'"' else option=""
execute_program_silent(ffmpeg+' -i "'+argument0+'" '+option+' "'+framepath+'frame%06d.png"')
if (!gifmode) {
    status.str="Exporting audio..." screen_redraw() io_handle()
    execute_program_silent(ffmpeg+' -i "'+argument0+'" -vn -ab '+string(abitrate)+'k -y "'+audiopath+'"')
}
sleep(100)

//initialize buffers
b=buffer_create()
b2=buffer_create()
buffer_write_string(b,"renex audiovideo v2")

//add audio blob
if (!file_exists(audiopath)) {
    buffer_write_u32(b,0)
} else {
    buffer_load(b2,audiopath)
    len=buffer_get_size(b2)
    buffer_write_u32(b,len)
    buffer_copy(b,b2)
    file_delete(audiopath)
}

//get all frames in order and count them
list=file_find_list(framepath,"*.png",0,0,1)
ds_list_sort(list,1)
count=ds_list_size(list)

//write movie header
buffer_write_float(b,videofps)
buffer_write_u32(b,count)
buffer_write_u16(b,w)
buffer_write_u16(b,h)

//write frames
keyframes=0
firstframe=true
i=0 repeat (count) {
    if (keyboard_check_direct(vk_escape)) {
        status.str="Operation cancelled."
        if (surface_exists(su)) surface_free(su) su=-1
        if (surface_exists(render)) surface_free(render) render=-1
        repeat (count-i) {
            file_delete(ds_list_find_value(list,i))
        i+=1}
        buffer_destroy(b)
        buffer_destroy(b2)
        encoding=false
        exit
    }
    //load a frame
    fn=ds_list_find_value(list,i)
    bg=background_add(fn,0,0)

    //initialize surface(s)
    if (!surface_exists(su)) {
        if (su!=-1) show_message("Warning: surface was lost during encode!##This might result in video artifacts.")
        su=surface_create(w,h)
    }
    if (!surface_exists(render)) {
        if (render!=-1) show_message("Warning: surface was lost during encode!##This might result in video artifacts.")
        render=surface_create(w,h)
        surface_set_target(render)
        draw_background(bg,0,0)
        surface_reset_target()
    }

    //prepare frame
    iskeyframe=false
    if (interval) if (!(i mod interval)) iskeyframe=true
    if (firstframe) iskeyframe=true
    firstframe=false
    shader_pixel_set(global.encodeshader)
    texture_set_stage("rPrevious",surface_get_texture(render))
    if (iskeyframe) {
        shader_pixel_uniform_f("tolerance",-1)
        keyframe[keyframes]=buffer_get_pos(b) keyframes+=1
    } else {
        shader_pixel_uniform_f("tolerance",delta/256)
    }

    //render frame data
    surface_set_target(su)
    draw_clear_alpha(0,0)
    draw_background(bg,0,0)
    shader_reset()

    //update render image
    surface_set_target(render)
    shader_pixel_uniform_f("tolerance",-1)
    draw_surface(su,0,0)

    //encode frame
    buffer_get_surface(b2,su)
    buffer_deflate(b2)
    buffer_write_u32(b,buffer_get_size(b2))
    buffer_copy(b,b2)

    //finalize
    background_delete(bg)
    file_delete(fn)
    surface_reset_target()

    //update window
    status.str="Encoding: "+string(round(i/count*100))+"%" set_application_title(status.str) screen_redraw() io_handle()
i+=1}

buffer_write_u32(b,keyframes)

i=0 repeat (keyframes) {
    buffer_write_u32(b,keyframe[i])
i+=1}

//save video file
buffer_save(b,output)
encoded=true

status.str="Finished! Size: "+string(buffer_get_size(b)/1024/1024)+" MB"
set_application_title("Video Encoder")

//cleanup
buffer_destroy(b)
buffer_destroy(b2)
if (surface_exists(su)) surface_free(su) su=-1
if (surface_exists(render)) surface_free(render) render=-1
shader_reset()
encoding=false
