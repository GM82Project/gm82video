fn=filename_change_ext(filename_name(parameter_string(0)),"")+".ini"

if (!file_exists(fn)) {
    //ok first we try path
    global.ffmpeg=""
    repeat (string_token_start(environment_get_variable("PATH"),";")) {
        dir=string_token_next()
        fn=dir+"\ffmpeg.exe"
        if (file_exists(fn)) {
            global.ffmpeg=fn
            break
        }
        fn=dir+"\ffmpeg\ffmpeg.exe"
        if (file_exists(fn)) {
            global.ffmpeg=fn
            break
        }
    }

    if (global.ffmpeg=="") {
        if (!show_question(
            "Welcome to the 8.2 Video Encoder!##"+
            "Since this is the first time you've started the program, we need to know where your copy of FFMPEG.EXE is located.##"+
            "Do you have FFMPEG binaries ready for use in your system? You can get Windows binaries on the Internet."
        )) {game_end() exit}

        global.ffmpeg=get_open_filename("FFMPEG.EXE|FFMPEG.EXE","ffmpeg.exe")
    }

    if (global.ffmpeg=="") {game_end() exit}

    save_ini()
} else {
    ini_open(fn)
    global.ffmpeg=ini_read_string("encoder","ffmpeg","")
    if (global.ffmpeg=="") {
        show_message("FFMPEG.EXE could not be located at the usual location. Please select FFMPEG.EXE again.")
        global.ffmpeg=get_open_filename("FFMPEG.EXE|FFMPEG.EXE","ffmpeg.exe")
        if (global.ffmpeg=="") {
            game_end() exit
        }
    }
    Scaling.scaling=ini_read_real("encoder","scale",1)
    Abitrate.bitrate=ini_read_real("encoder","bitrate",80)
    Delta.delta=ini_read_real("encoder","delta",10)
    Keyframe.keyframe=ini_read_real("encoder","keyframe",20)
    ini_close()
}
