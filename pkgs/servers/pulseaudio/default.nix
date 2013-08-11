{ stdenv, fetchurl, pkgconfig, gnum4, gdbm, libtool, glib, dbus, avahi
, gconf, gtk, intltool, gettext
, alsaLib, libsamplerate, libsndfile, speex, bluez, sbc, udev, libcap
, jackaudioSupport ? false, jackaudio ? null
, x11Support ? false, xlibs
, json_c
, useSystemd ? false, systemd ? null
}:

assert jackaudioSupport -> jackaudio != null;

stdenv.mkDerivation rec {
  name = "pulseaudio-4.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-4.0.tar.xz";
    sha256 = "1bndz4l8jxyq3zq128gzp3gryxl6yjs66j2y1d7yabw2n5mv7kim";
  };

  # Since `libpulse*.la' contain `-lgdbm' and `-lcap', it must be propagated.
  propagatedBuildInputs = [ gdbm libcap ];

  buildInputs =
    [ pkgconfig gnum4 libtool intltool glib dbus avahi
      libsamplerate libsndfile speex alsaLib bluez sbc udev
      json_c
      #gtk gconf 
    ]
    ++ stdenv.lib.optional jackaudioSupport jackaudio
    ++ stdenv.lib.optionals x11Support [ xlibs.xlibs xlibs.libXtst xlibs.libXi ]
    ++ stdenv.lib.optional useSystemd systemd;

  preConfigure = ''

    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

   # don't install proximity-helper as root and setuid
   sed -i "src/Makefile.in" \
       -e "s|chown root|true |" \
       -e "s|chmod r+s |true |"
  '';

  configureFlags = ''
    --disable-solaris --disable-hal --disable-jack
    --disable-oss-output --disable-oss-wrapper
    --localstatedir=/var --sysconfdir=/etc
    ${if jackaudioSupport then "--enable-jack" else ""}
  '';

  installFlags = "sysconfdir=$(out)/etc pulseconfdir=$(out)/etc/pulse";

  enableParallelBuilding = true;

  meta = {
    description = "PulseAudio, a sound server for POSIX and Win32 systems";

    longDescription = ''
      PulseAudio is a sound server for POSIX and Win32 systems.  A
      sound server is basically a proxy for your sound applications.
      It allows you to do advanced operations on your sound data as it
      passes between your application and your hardware.  Things like
      transferring the audio to a different machine, changing the
      sample format or channel count and mixing several sounds into
      one are easily achieved using a sound server.
    '';

    homepage = http://www.pulseaudio.org/;

    # Note: Practically, the server is under the GPL due to the
    # dependency on `libsamplerate'.  See `LICENSE' for details.
    licenses = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
