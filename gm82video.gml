#define __gm82video_init
    ///    
    object_event_add(__gm82video_object,ev_step,ev_step_begin,"
        __gm82video_step()
    ")
    object_set_persistent(__gm82video_object,true)


#define __gm82video_step
    ///
    var __position,__update,__len,__pos,__key,__timer;
    
    if (__gm82video_playing) {    
        if (__gm82video_soundtrack=="") {
            //alternate timing
            __position=__gm82video_current
            __timer=get_timer()
            if (__timer>=__gm82video_lastframe+__gm82video_frametime/__gm82video_speed || __gm82video_current==-1) {
                __position=__gm82video_current+1
                __gm82video_lastframe=__timer
            }
        } else {
            //normal timing
            if (!sound_isplaying(__gm82video_sound)) {
                __position=0
                __gm82video_playing=false
            } else __position=round(min(1,sound_get_pos(__gm82video_sound,unit_unitary))*__gm82video_total)
        }        
        
        while (__position>__gm82video_current && __gm82video_current<__gm82video_total-1) { 
            __gm82video_current+=1
            buffer_clear(__gm82video_framebuffer)
            
            //unpack one frame
            __len=buffer_read_u32(__gm82video_buffer)
            __pos=buffer_get_pos(__gm82video_buffer)
            buffer_copy_part(__gm82video_framebuffer,__gm82video_buffer,__pos,__len)
            buffer_inflate(__gm82video_framebuffer)
            buffer_set_pos(__gm82video_buffer,__pos+__len)            
            __gm82video_update_frame()
        }
        
        if (__gm82video_current>=__gm82video_total-1) {
            if (__gm82video_loop) video_reset(id)
            else __gm82video_playing=false
        }
    }


#define __gm82video_update_frame
    ///    
    var __size,__cur;
    
    if (!surface_exists(__gm82video_surface))
        __gm82video_surface=surface_create(__gm82video_width,__gm82video_height)
    if (!surface_exists(__gm82video_scratch))
        __gm82video_scratch=surface_create(__gm82video_width,__gm82video_height)
    __size=__gm82video_width*__gm82video_height*4
    __cur=buffer_get_size(__gm82video_framebuffer)
    if (__cur!=__size) {
        show_error("error decoding frame ("+string(__gm82video_current)+"/"+string(__gm82video_total)+"): buffer size was invalid ("+string(__cur)+"/"+string(__size)+")",0)
        return -1
    }
    
    buffer_set_surface(__gm82video_framebuffer,__gm82video_scratch)
    surface_set_target(__gm82video_surface)
    draw_surface(__gm82video_scratch,0,0)
    surface_reset_target()


#define video_play
    ///video_play(filename.rv2,[loop])
    //Loads a video and returns a video instance.
    var __loop;
    
    __loop=0
    if (argument_count>1) __loop=argument[1]
    
    if (!file_exists(argument[0])) {
        show_error("error in function video_play: loading nonexisting file ("+string(argument[0])+")",0)
        return noone
    }
    
    with (instance_create(0,0,__gm82video_object)) {        
        __gm82video_buffer=buffer_create()
        __gm82video_framebuffer=buffer_create()
        var __i; __i=0 do {__gm82video_audiofile=temp_directory+"\"+filename_name(argument[0])+string(__i)+".mp3" __i+=1} until (!file_exists(__gm82video_audiofile))

        //load movie data
        buffer_load(__gm82video_buffer,argument[0])

        //renex audiovideo v1
        if (buffer_read_string(__gm82video_buffer)!="renex audiovideo v2") {
            show_error("error in function video_play: file does not appear to be a rav codec blob ("+string(argument[0])+")",0)
            buffer_destroy(__gm82video_buffer)
            buffer_destroy(__gm82video_framebuffer)
            instance_destroy()
            return noone
        }

        //read audio blob
        __len=buffer_read_u32(__gm82video_buffer)
        
        if (__len==0) {
            __gm82video_soundtrack=""
        } else {
            __pos=buffer_get_pos(__gm82video_buffer)
            buffer_copy_part(__gm82video_framebuffer,__gm82video_buffer,__pos,__len)
            buffer_set_pos(__gm82video_buffer,__pos+__len)
            buffer_save(__gm82video_framebuffer,__gm82video_audiofile)
            __gm82video_soundtrack=sound_add(__gm82video_audiofile,3,1)
            buffer_clear(__gm82video_framebuffer)
        }

        //read movie header
        __gm82video_fps=buffer_read_float(__gm82video_buffer)
        __gm82video_total=buffer_read_u32(__gm82video_buffer)

        //read frame size and initialize frame surface
        __gm82video_width=buffer_read_u16(__gm82video_buffer)
        __gm82video_height=buffer_read_u16(__gm82video_buffer)
       
        //initialize variables
        __gm82video_1stframe=buffer_get_pos(__gm82video_buffer)
        __gm82video_surface=-1
        __gm82video_scratch=-1
        __gm82video_current=-1
        __gm82video_speed=1
        __gm82video_playing=1
        __gm82video_loop=__loop
        
        //play soundtrack
        if (__gm82video_soundtrack!="")
            __gm82video_sound=sound_play(__gm82video_soundtrack)
        else
            __gm82video_lastframe=get_timer()
            __gm82video_frametime=1000000/__gm82video_fps
        
        //load first frame
        __gm82video_step()
        
        return id
    }


#define video_reset
    ///video_reset(video)
    //Resets the video to play from the beginning.
    with (argument0) if (object_index==__gm82video_object) {
        buffer_set_pos(__gm82video_buffer,__gm82video_1stframe)
        __gm82video_current=-1
        if (__gm82video_soundtrack!="") {
            sound_stop(__gm82video_sound)
            __gm82video_sound=sound_play(__gm82video_soundtrack)
            sound_pitch(__gm82video_sound,__gm82video_speed)
        }
        __gm82video_playing=1
        return 0        
    }
    show_error("Invalid video instance passed to function video_reset ("+string(argument0)+")",0)
    return -1
    

#define video_get_size
    ///video_get_size(video)
    //Returns the size in memory of the video in bytes.
    with (argument0) if (object_index==__gm82video_object) {
        return buffer_get_size(__gm82video_buffer)
    }
    show_error("Invalid video instance passed to function video_get_width ("+string(argument0)+")",0)
    return -1


#define video_get_width
    ///video_get_width(video)
    //Returns the width of the video in pixels.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_width
    }
    show_error("Invalid video instance passed to function video_get_width ("+string(argument0)+")",0)
    return -1


#define video_get_height
    ///video_get_height(video)
    //Returns the height of the video in pixels.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_height
    }
    show_error("Invalid video instance passed to function video_get_height ("+string(argument0)+")",0)
    return -1


#define video_get_fps
    ///video_get_fps(video)
    //Returns the video's frames per second.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_fps
    }
    show_error("Invalid video instance passed to function video_get_fps ("+string(argument0)+")",0)
    return -1


#define video_get_frames
    ///video_get_frames(video)
    //returns the total number of frames in the video.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_total-1
    }
    show_error("Invalid video instance passed to function video_get_frames ("+string(argument0)+")",0)
    return -1


#define video_get_length
    ///video_get_length(video)
    //returns the length of the video in seconds.
    with (argument0) if (object_index==__gm82video_object) {
        return (__gm82video_total-1)/__gm82video_fps
    }
    show_error("Invalid video instance passed to function video_get_length ("+string(argument0)+")",0)
    return -1


#define video_get_progress
    ///video_get_progress(video)
    //returns the play progress of the video from 0 to 1.
    with (argument0) if (object_index==__gm82video_object) {
        return max(0,__gm82video_current)/(__gm82video_total-1)
    }
    show_error("Invalid video instance passed to function video_get_progress ("+string(argument0)+")",0)
    return -1


#define video_get_surface
    ///video_get_surface(video)
    //returns a surface with the current video frame for the video.
    with (argument0) if (object_index==__gm82video_object) {
        if (!surface_exists(__gm82video_surface))
            __gm82video_update_frame()
        return __gm82video_surface
    }
    show_error("Invalid video instance passed to function video_get_surface ("+string(argument0)+")",0)
    return -1


#define video_get_texture
    ///video_get_texture(video)
    //returns a texture with the current video frame for the video.
    with (argument0) if (object_index==__gm82video_object) {
        if (!surface_exists(__gm82video_surface))
            __gm82video_update_frame()
        return surface_get_texture(__gm82video_surface)
    }
    show_error("Invalid video instance passed to function video_get_texture ("+string(argument0)+")",0)
    return -1


#define video_set_volume
    ///video_set_volume(video,volume)
    //Sets the audio volume for the video.
    with (argument0) if (object_index==__gm82video_object) {
        if (__gm82video_soundtrack!="") sound_volume(__gm82video_sound,argument1)
        return 1
    }
    show_error("Invalid video instance passed to function video_set_volume ("+string(argument0)+")",0)
    return -1


#define video_set_pause
    ///video_set_pause(video,paused)
    //Pauses or unpauses video playback.
    with (argument0) if (object_index==__gm82video_object) {
        __gm82video_playing=!argument1
        if (__gm82video_soundtrack!="") {
            if (__gm82video_playing) sound_resume(__gm82video_sound)
            else sound_pause(__gm82video_sound)
        }
        return 1
    }
    show_error("Invalid video instance passed to function video_set_pause ("+string(argument0)+")",0)
    return -1


#define video_set_speed
    ///video_set_speed(video,speed)
    //Sets video playback speed from 0 to 4x.
    with (argument0) if (object_index==__gm82video_object) {
        __gm82video_speed=median(0,argument1,4)
        if (__gm82video_soundtrack!="") sound_pitch(__gm82video_sound,__gm82video_speed)
        
        return 1
    }
    show_error("Invalid video instance passed to function video_set_speed ("+string(argument0)+")",0)
    return -1


#define video_set_loop
    ///video_set_loop(video,loop)
    //Sets video loop setting.
    with (argument0) if (object_index==__gm82video_object) {
        __gm82video_loop=!!argument0        
        return 1
    }
    show_error("Invalid video instance passed to function video_set_loop ("+string(argument0)+")",0)
    return -1


#define video_isplaying
    ///video_isplaying(video)
    //Returns whether a non-looped video is still not done playing.
    with (argument0) if (object_index==__gm82video_object) {
        return __gm82video_playing
    }
    show_error("Invalid video instance passed to function video_isplaying ("+string(argument0)+")",0)
    return -1


#define video_destroy
    ///video_destroy(video)
    //Destroys a video and frees all associated memory.
    with (argument0) if (object_index==__gm82video_object) {
        if (__gm82video_soundtrack!="") {
            sound_stop(__gm82video_sound)
            sound_delete(__gm82video_soundtrack)
        }
        buffer_destroy(__gm82video_buffer)
        buffer_destroy(__gm82video_framebuffer)
        file_delete(__gm82video_audiofile)
        if (surface_exists(__gm82video_surface)) surface_free(__gm82video_surface)
        instance_destroy()
        
        return 0
    }
    show_error("Invalid video instance passed to function video_destroy ("+string(argument0)+")",0)
    return -1


#define video_draw
    ///video_draw(video,x,y,[w,h,[color,alpha]])
    //Simple function for drawing the video to a rectangle.
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
//
//