using VideoIO, Images
include("control.jl")

"""
    getc1()

Util function to quit the loop
"""
function getc1()
    ret = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, true)
    ret == 0 || error("unable to switch to raw mode")
    c = read(stdin, Char)
    ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, false)
    c
end

"""
    getc1()

Main function which starts the video feed
    and calls subsequent functions
"""
function start()
    cam = VideoIO.opencamera()
    display = _getDisplay()
    n = 0
    while true
        n += 1
        # opt = getc1();
        # if opt == 'q'
        #     break
        # end
        if n%10 != 0
            continue
        end
        rgb_img = read(cam)
        hsl_img = HSL.(rgb_img)
        channels = channelview(float.(hsl_img))
        L = channels[3,:,:]
        brightness = sum(L)/length(L)
        _setBrightness(display, brightness)
    end
end

start()