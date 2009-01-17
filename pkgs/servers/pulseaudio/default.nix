{ stdenv, fetchurl, pkgconfig, gnum4, gdbm, libtool, glib, dbus, hal, avahi
, gconf, liboil, intltool, gettext
, libsamplerate, libsndfile, speex }:

stdenv.mkDerivation rec {
  name = "pulseaudio-0.9.13";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/pulseaudio/${name}.tar.gz";
    sha256 = "0lwd5rcppyvcvy9n2j074k5mydgqszfvw6fnsjlz46gkda9vgydq";
  };

  buildInputs = [
    pkgconfig gnum4 gdbm libtool glib dbus hal avahi gconf liboil
    libsamplerate libsndfile speex
    intltool gettext
  ];

  configureFlags = ''
    --disable-solaris --disable-jack --disable-bluez --disable-polkit --localstatedir=/var
  '';

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
  };
}
