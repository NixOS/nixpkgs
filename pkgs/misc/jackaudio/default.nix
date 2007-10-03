# Perhaps we can get some ideas from here ? http://gentoo-wiki.com/HOWTO_Jack 
# still much to test but it compiles now
args:
args.mkDerivationByConfigruation {
    flagConfig = {
    mandatory = { buildInputs = [ ];};

    # static[=PKGS] =     { cfgOption = "--enable-static[=PKGS]"; };                  #build static libraries [default=no]
    # shared[=PKGS] =     { cfgOption = "--enable-shared[=PKGS]"; };                  #build shared libraries [default=yes]
    posix_shm =         { cfgOption = "--enable-posix-shm"; };                      #use POSIX shm API
    # altivec seems to be for mac only ?
    #  altivec =           { cfgOption = "--enable-altivec"; };                        #enable Altivec support (default=auto)

    # keeping default values by now:
    # optimization_by_compiler = { cfgOption = "--enable-optimization-by-compiler"; }; [>use compiler (NOT processor) capabilities to determine optimization flags
    # optimization_by_cpu = { cfgOption = "--enable-optimization-by-cpu"; };          [>use processor capabilities to determine optimization flags

    # I think the default is ok
    # mmx =               { cfgOption = "--enable-mmx"; };                            #enable MMX support (default=auto)
    sse =               { cfgOption = "--enable-sse"; };                            #enable SSE support (default=auto)
    dynsimd =           { cfgOption = "--enable-dynsimd"; };                        #enable dynamic SIMD selection (default=no)
    optimize =          { cfgOption = "--enable-optimize"; };                       #ask the compiler for its best optimizations
    resize =            { cfgOption = "--enable-resize"; };                         #enable buffer resizing feature
    ensure_mlock =      { cfgOption = "--enable-ensure-mlock"; };                   #fail if unable to lock memory
    debug =             { cfgOption = "--enable-debug"; };                          #enable debugging messages in jackd and libjack
    timestamps =        { cfgOption = "--enable-timestamps"; };                     #allow clients to use the JACK timestamp API
    preemption_check =  { cfgOption = "--enable-preemption-check"; };               #

    capabilities =      { cfgOption = "--enable-capabilities"; };                   #use libcap to gain realtime scheduling priviledges
    no_oldtrans =       { cfgOption = "--disable-oldtrans"; };                      #remove old transport interfaces
    stripped_jackd =    { cfgOption = "--enable-stripped-jackd"; };                 #strip jack before computing its md5 sum
    no_portaudio =      { cfgOption = "--disable-portaudio"; };                     #ignore PortAudio driver
    no_coreaudio =      { cfgOption = "--disable-coreaudio"; };                     #ignore CoreAudio driver
    no_oss =            { cfgOption = "--disable-oss"; };                           #ignore OSS driver
    no_freebob =        { cfgOption = "--disable-freebob"; };                       #ignore FreeBob driver
    no_alsa =           { cfgOption = "--disable-alsa"; };                          #ignore ALSA driver

    }; 

    extraAttrs = co : {
      name = "jack-0.103.0";

      src = args.fetchurl {
        url = "http://prdownloads.sourceforge.net/jackit/jack-audio-connection-kit-0.103.0.tar.gz";
        sha256 = "0pr3vxsfignvc9kls52zvyxhl7mwan0nhnlvcz3s3r3ydmlzvnd5";
      };

      meta = { 
        description = "jack audio connection kit";
        homepage = "http://jackaudio.org";
        license = "GPL";
      };
    };
} args
