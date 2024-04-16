#define __gm82video_init
    ///    
    object_event_add(__gm82video_object,ev_step,ev_step_begin,"
        __gm82video_step()
    ")


#define __gm82video_step
    ///
    var __timer;    
    __timer=get_timer()
    
    if (__timer>__gm82video_lastframe+__gm82video_frametime) {
        if (__gm82video_lastframe==-1) __gm82video_lastframe=__timer
        __gm82video_lastframe+=__gm82video_frametime
        __gm82video_current+=1
        
        if (__gm82video_current>=__gm82video_total) {
            buffer_destroy(__gm82video_buffer)
            buffer_destroy(__gm82video_framebuffer)
            sound_stop(__gm82video_sound)
            sound_delete(__gm82video_soundtrack)
            file_delete(__gm82video_audiofile)
            instance_destroy()
            return 0
        }
        
        buffer_clear(__gm82video_framebuffer)
        __len=buffer_read_u32(__gm82video_buffer)
        __pos=buffer_get_pos(__gm82video_buffer)
        buffer_copy_part(__gm82video_framebuffer,__gm82video_buffer,__pos,__len)
        buffer_inflate(__gm82video_framebuffer)
        buffer_set_pos(__gm82video_buffer,__pos+__len)
        
        __gm82video_update_frame()
    }


#define __gm82video_update_frame
    ///    
    var __size,__cur;
    
    if (!surface_exists(__gm82video_surface))
        __gm82video_surface=surface_create(__gm82video_width,__gm82video_height)
    __size=__gm82video_width*__gm82video_height*4
    __cur=buffer_get_size(__gm82video_framebuffer)
    if (__cur!=__size) {
        show_error("error decoding frame ("+string(__gm82video_current)+"/"+string(__gm82video_total)+"): buffer size was invalid ("+string(__cur)+"/"+string(__size)+")",0)
        return -1
    }
    
    buffer_set_surface(__gm82video_framebuffer,__gm82video_surface)


#define video_play
    ///video_play(filename.rav)
    //Loads a video and returns a video instance.
    
    if (!file_exists(argument0)) {
        show_error("error in function video_play: loading video from nonexisting file ("+string(argument0)+")",0)
        return -1
    }
    
    globalvar __gm82video_using_gm82snd;
    __gm82video_using_gm82snd=variable_global_exists("__gm82snd_checkerrors")
    
    with (instance_create(0,0,__gm82video_object)) {        
        __gm82video_buffer=buffer_create()
        __gm82video_framebuffer=buffer_create()
        __gm82video_audiofile=temp_directory+"\"+filename_name(argument0)+string(irandom(1000000))+".mp3"

        //load movie data
        buffer_load(__gm82video_buffer,argument0)

        //renex audiovideo v1
        if (buffer_read_string(__gm82video_buffer)!="renex audiovideo v1 ") {
            show_error("",0)
            buffer_destroy(__gm82video_buffer)
            buffer_destroy(__gm82video_framebuffer)
            instance_destroy()
            return -1
        }

        //read audio blob
        __len=buffer_read_u32(__gm82video_buffer)
        __pos=buffer_get_pos(__gm82video_buffer)
        buffer_copy_part(__gm82video_framebuffer,__gm82video_buffer,__pos,__len)
        buffer_set_pos(__gm82video_buffer,__pos+__len)
        buffer_save(__gm82video_framebuffer,__gm82video_audiofile)
        __gm82video_soundtrack=sound_add(__gm82video_audiofile,3,1)
        buffer_clear(__gm82video_framebuffer)

        //read movie header
        __gm82video_fps=buffer_read_float(__gm82video_buffer)
        __gm82video_total=buffer_read_u32(__gm82video_buffer)

        //read frame size and initialize frame surface
        __gm82video_width=buffer_read_u16(__gm82video_buffer)
        __gm82video_height=buffer_read_u16(__gm82video_buffer)
       
        //initialize variables
        __gm82video_surface=-1
        __gm82video_lastframe=-1
        __gm82video_current=-1
        __gm82video_frametime=1000000/__gm82video_fps
        
        //load first frame
        __gm82video_step()
        
        //play soundtrack
        __gm82video_sound=sound_play(__gm82video_soundtrack)
        if (!__gm82video_using_gm82snd) __gm82video_sound=__gm82video_soundtrack
        
        return id
    }


#define video_get_width
    ///video_get_width(video)
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_width
    }
    show_error("Invalid video instance passed to function video_get_width ("+string(argument0)+")",0)
    return -1


#define video_get_height
    ///video_get_height(video)
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_height
    }
    show_error("Invalid video instance passed to function video_get_height ("+string(argument0)+")",0)
    return -1


#define video_get_fps
    ///video_get_fps(video)
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_fps
    }
    show_error("Invalid video instance passed to function video_get_fps ("+string(argument0)+")",0)
    return -1


#define video_get_frames
    ///video_get_frames(video)
    //returns the length of the video in frames.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_total
    }
    show_error("Invalid video instance passed to function video_get_frames ("+string(argument0)+")",0)
    return -1


#define video_get_length
    ///video_get_length(video)
    //returns the length of the video in seconds.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_total/__gm82video_fps
    }
    show_error("Invalid video instance passed to function video_get_length ("+string(argument0)+")",0)
    return -1


#define video_get_progress
    ///video_get_progress(video)
    //returns the play percentage for the video.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_current/__gm82video_total
    }
    show_error("Invalid video instance passed to function video_get_progress ("+string(argument0)+")",0)
    return -1


#define video_get_surface
    ///video_get_surface(video)
    //returns a surface with the current video frame for that video.
    var __video;
    
    __video=argument0
    
    with (__video) if (object_index==__gm82video_object) {
        if (!surface_exists(__gm82video_surface))
            __gm82video_update_frame()
        return __gm82video_surface
    }
    show_error("Invalid video instance passed to function video_get_surface ("+string(argument0)+")",0)
    return -1


#define video_set_volume
    ///video_set_volume(video,volume)
    with (argument0) if (object_index==__gm82video_object) {
        sound_volume(__gm82video_sound,argument1)
        return 1
    }
    show_error("Invalid video instance passed to function video_set_volume ("+string(argument0)+")",0)
    return -1


#define video_set_pause
    ///video_set_pause(video,paused)
    with (argument0) if (object_index==__gm82video_object) {
        if (!__gm82video_using_gm82snd) {
            show_error("trying to pause video, but Game Maker 8.2 Sound extension is not present.",0)
            return -1
        }
        __gm82video_playing=!argument1
        if (__gm82video_playing) sound_resume(__gm82video_sound)
        else sound_pause(__gm82video_sound)
        return 1
    }
    show_error("Invalid video instance passed to function video_set_pause ("+string(argument0)+")",0)
    return -1


#define video_set_speed
    ///video_set_speed(video,speed)
    with (argument0) if (object_index==__gm82video_object) {
        if (!__gm82video_using_gm82snd) {
            show_error("trying to change video speed, but Game Maker 8.2 Sound extension is not present.",0)
            return -1
        }
        __gm82video_speed=median(0,argument1,5)
        sound_pitch(__gm82video_sound,__gm82video_speed)
        
        return 1
    }
    show_error("Invalid video instance passed to function video_set_speed ("+string(argument0)+")",0)
    return -1


#define video_draw
    ///video_draw(video,x,y,[w,h,[color,alpha]])
    //Shortcut for drawing the video.
    var __w,__h,__c,__a;
    
    with (argument[0]) if (object_index==__gm82video_object) {
        __w=__gm82video_width
        __h=__gm82video_height
        __c=$ffffff
        __a=1
        
        if (argument_count==3) {            
        } else if (argument_count==5) {
            __w=argument[3]
            __h=argument[4]
        } else if (argument_count==7) {
            __c=argument[5]
            __a=argument[6]
        } else {
            show_error("Invalid number of arguments passed to function video_draw ("+string(argument_count)+")",0)
            return -1
        }
        
        if (!surface_exists(__gm82video_surface))
            __gm82video_update_frame()
        
        draw_surface_stretched_ext(__gm82video_surface,argument[1],argument[2],__w,__h,__c,__a)
        
        return 1
    }
    show_error("Invalid video instance passed to function video_draw ("+string(argument0)+")",0)
    return -1


#define video_encode
    ///video_encode(ffmpeg.exe,filename,scaling%)
    //todo: encode video
//
//