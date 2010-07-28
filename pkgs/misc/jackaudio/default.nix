# Perhaps we can get some ideas from here ? http://gentoo-wiki.com/HOWTO_Jack
# still much to test but it compiles now

{ composableDerivation, fetchurl, pkgconfig, alsaLib }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {
  name = "jack-0.103.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/jackit/jack-audio-connection-kit-0.109.2.tar.gz";
    sha256 = "1m5z8dzalqspsa63pkcgyns0cvh0kqwhb9g1ivcwvnz0bc7ag9r7";
  };
  
  buildInputs = [ pkgconfig ];
  
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
    // edf { name = "alsa"; enable = { buildInputs = [ alsaLib ]; }; };

  cfg = {
    posix_shmSupport = true;
    timestampsSupport = true;
    alsaSupport = true;
  };
  
  # make sure the jackaudio is found by symlinking lib64 to lib
  postInstall = ''
    ensureDir $out/lib
    ln -s $out/lib{64,}/pkgconfig
  '';
  
  meta = {
    description = "JACK audio connection kit";
    homepage = "http://jackaudio.org";
    license = "GPL";
  };
}
