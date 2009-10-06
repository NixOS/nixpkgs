{ stdenv, fetchurl, pkgconfig, gnum4, gdbm, libtool, glib, dbus, hal, avahi
, gconf, liboil, libX11, libICE, libSM, intltool, gettext, alsaLib
, libsamplerate, libsndfile, speex, ... }:

stdenv.mkDerivation rec {
  name = "pulseaudio-0.9.13";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/pulseaudio/${name}.tar.gz";
    sha256 = "0lwd5rcppyvcvy9n2j074k5mydgqszfvw6fnsjlz46gkda9vgydq";
  };

  # Since `libpulse*.la' contain `-lgdbm', it must be propagated.
  propagatedBuildInputs = [ gdbm ];

  buildInputs = [
    pkgconfig gnum4 libtool glib dbus hal avahi gconf liboil
    libsamplerate libsndfile speex alsaLib
    libX11 libICE libSM
    intltool gettext
  ];

  preConfigure = ''
    # Disable the ConsoleKit module since we don't currently have that
    # on NixOS.
    sed -i "src/daemon/default.pa.in" \
        -e 's/^\( *load-module \+module-console-kit\)/# \1/g'

    # Change the `padsp' script so that it contains the full path to
    # `libpulsedsp.so'.
    sed -i "src/utils/padsp" \
        -e "s|libpulsedsp\.so|$out/lib/libpulsedsp.so|g"
  '';

  configureFlags = ''
    --disable-solaris --disable-jack --disable-bluez --disable-polkit --with-x --enable-asyncdns --localstatedir=/var
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
