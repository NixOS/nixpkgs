{ stdenv, fetchurl, pkgconfig, gnum4, gdbm, libtool, glib, dbus, avahi
, gconf, gtk, intltool, gettext, alsaLib, libsamplerate, libsndfile, speex
, bluez, sbc, udev, libcap, json_c
, jackaudioSupport ? false, jackaudio ? null
, x11Support ? false, xlibs
, useSystemd ? false, systemd ? null }:

assert jackaudioSupport -> jackaudio != null;

stdenv.mkDerivation rec {
  name = "pulseaudio-4.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-4.0.tar.xz";
    sha256 = "1bndz4l8jxyq3zq128gzp3gryxl6yjs66j2y1d7yabw2n5mv7kim";
  };

  # Since `libpulse*.la' contain `-lgdbm' and `-lcap', it must be propagated.
  propagatedBuildInputs
    = [ gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ pkgconfig gnum4 libtool intltool glib dbus avahi libsamplerate libsndfile
      speex json_c ]
    ++ stdenv.lib.optional jackaudioSupport jackaudio
    ++ stdenv.lib.optionals x11Support [ xlibs.xlibs xlibs.libXtst xlibs.libXi ]
    ++ stdenv.lib.optional useSystemd systemd
    ++ stdenv.lib.optionals stdenv.isLinux [ alsaLib bluez sbc udev ];

  preConfigure = ''
    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

   # don't install proximity-helper as root and setuid
   sed -i "src/Makefile.in" \
       -e "s|chown root|true |" \
       -e "s|chmod r+s |true |"
  '';

  configureFlags =
    [ "--disable-solaris" "--disable-jack" "--disable-oss-output"
      "--disable-oss-wrapper" "--localstatedir=/var" "--sysconfdir=/etc" ]
    ++ stdenv.lib.optional jackaudioSupport "--enable-jack"
    ++ stdenv.lib.optional stdenv.isDarwin "--with-mac-sysroot=/";

  enableParallelBuilding = true;

  # not sure what the best practices are here -- can't seem to find a way
  # for the compiler to bring in stdlib and stdio (etc.) properly
  # the alternative is to copy the files from /usr/include to src, but there are
  # probably a large number of files that would need to be copied (I stopped
  # after the seventh)
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-I/usr/include";

  installFlags = "sysconfdir=$(out)/etc pulseconfdir=$(out)/etc/pulse";

  meta = with stdenv.lib; {
    description = "PulseAudio, a sound server for POSIX and Win32 systems";
    homepage    = http://www.pulseaudio.org/;
    # Note: Practically, the server is under the GPL due to the
    # dependency on `libsamplerate'.  See `LICENSE' for details.
    licenses    = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      PulseAudio is a sound server for POSIX and Win32 systems.  A
      sound server is basically a proxy for your sound applications.
      It allows you to do advanced operations on your sound data as it
      passes between your application and your hardware.  Things like
      transferring the audio to a different machine, changing the
      sample format or channel count and mixing several sounds into
      one are easily achieved using a sound server.
    '';
  };
}
