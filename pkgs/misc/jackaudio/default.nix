# Perhaps we can get some ideas from here ? http://gentoo-wiki.com/HOWTO_Jack
# still much to test but it compiles now
args:
let inherit (args.composableDerivation) composableDerivation edf; in
composableDerivation {} {
  buildInputs = [ args.pkgconfig ];
  flags =
      # FIXME: tidy up
       edf { name = "posix-shm"; } #use POSIX shm API
    // edf { name = "timestamps"; }                      # allow clients to use the JACK timestamp API
    // edf { name = "capabilities"; }                   #use libcap to gain realtime scheduling priviledges
    // edf { name = "oldtrans"; }                      #remove old transport interfaces
    // edf { name = "stripped-jackd"; }                 #strip jack before computing its md5 sum
    // edf { name = "portaudio"; }                     #ignore PortAudio driver
    // edf { name = "coreaudio"; }                     #ignore CoreAudio driver
    // edf { name = "oss"; }                           #ignore OSS driver
    // edf { name = "freebob"; }                       #ignore FreeBob driver
    // edf { name = "alsa"; enable = { buildInputs=[args.alsaLib]; }; };

    # altivec seems to be for mac only ?
    #  altivec =           { configureFlags = ["--enable-altivec"]; };                        #enable Altivec support (default=auto)

    # keeping default values by now:
    # optimization_by_compiler = { configureFlags = ["--enable-optimization-by-compiler"]; }; [>use compiler (NOT processor) capabilities to determine optimization flags
    # optimization_by_cpu = { configureFlags = ["--enable-optimization-by-cpu"]; };          [>use processor capabilities to determine optimization flags

    # I think the default is ok
    # mmx =              edf { name = "mmx"; };                           #enable MMX support (default=auto)
    #sse =               edf { name = "sse"; };                            #enable SSE support (default=auto)
    #dynsimd =           edf { name = "dynsimd"; };                        #enable dynamic SIMD selection (default=no)
    #optimize =          edf { name = "optimize"; };                       #ask the compiler for its best optimizations
    #resize =            edf { name = "resize"; };                         #enable buffer resizing feature
    #ensure_mlock =      edf { name = "ensure-mlock"; };                   #fail if unable to lock memory
    #debug =             edf { name = "debug"; };                          #enable debugging messages in jackd and libjack
    #preemption_check =  edf { name = "preemption-check"; };               #
  cfg = {
    posix_shmSupport = true;
    timestampsSupport = true;
    alsaSupport = true;
  };
  name = "jack-0.103.0";
  src = args.fetchurl {
    url = "mirror://sourceforge/jackit/jack-audio-connection-kit-0.109.2.tar.gz";
    sha256 = "1m5z8dzalqspsa63pkcgyns0cvh0kqwhb9g1ivcwvnz0bc7ag9r7";
  };
  meta = {
    description = "jack audio connection kit";
    homepage = "http://jackaudio.org";
    license = "GPL";
  };

  # make sure the jackaudio is found by symlinking lib64 to lib
  postInstall = ''
    ensureDir $out/lib
    ln -s $out/lib{64,}/pkgconfig
  '';
}
