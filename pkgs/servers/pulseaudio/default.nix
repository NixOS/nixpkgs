{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, intltool, autoreconfHook
, libsndfile, libtool
, xorg, libcap, alsaLib, glib
, avahi, libjack2, libasyncns, lirc, dbus
, orc, sbc, bluez5, udev, openssl, fftwFloat
, speexdsp, systemd, webrtc-audio-processing, gconf ? null

# Database selection
, tdb ? null, gdbm ? null

, x11Support ? false

, useSystemd ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, gconfSupport ? false

, bluetoothSupport ? false

, remoteControlSupport ? false

, zeroconfSupport ? false

, CoreServices, AudioUnit, Cocoa
}:

stdenv.mkDerivation rec {
  name = "pulseaudio-${version}";
  version = "11.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "17ndr6kc7hpv4ih4gygwlcpviqifbkvnk4fbwf4n25kpb991qlpj";
  };

  patches = [ ./caps-fix.patch ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "padsp-fix.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/testing/pulseaudio/0001-padsp-Make-it-compile-on-musl.patch?id=167be02bf4618a90328e2b234f6a63a5dc05f244";
      sha256 = "0gf4w25zi123ghk0njapysvrlljkc3hyanacgiswfnnm1i8sab1q";
    });

  outputs = [ "out" "dev" "bin" "daemon" ];

  nativeBuildInputs = [ pkgconfig intltool autoreconfHook ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ libtool libsndfile speexdsp fftwFloat orc ]
    ++ lib.optionals stdenv.isLinux [ glib dbus ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices AudioUnit Cocoa ]
    ++ [ libasyncns webrtc-audio-processing ]
    ++ lib.optional jackaudioSupport libjack2
    ++ lib.optionals x11Support [ xorg.libxcb xorg.libX11 xorg.libSM xorg.libICE xorg.libXtst xorg.libXi ]
    ++ lib.optional useSystemd systemd
    ++ lib.optionals stdenv.isLinux [ alsaLib udev ]
    ++ lib.optional airtunesSupport openssl
    ++ lib.optional gconfSupport gconf
    ++ lib.optionals bluetoothSupport [ bluez5 sbc ]
    ++ lib.optional remoteControlSupport lirc
    ++ lib.optional zeroconfSupport  avahi
    ;

  configureFlags =
    [ "--disable-solaris"
      "--disable-jack"
      "--disable-oss-output"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-access-group=audio"
    ]
    ++ lib.optional (!ossWrapper) "--disable-oss-wrapper"
    ++ lib.optional (jackaudioSupport) "--enable-jack"
    ++ lib.optional stdenv.isDarwin "--with-mac-sysroot=/"
    ++ lib.optional (stdenv.isLinux && useSystemd) "--with-systemduserunitdir=\${daemon}/lib/systemd/user";


  preConfigure = ''
    # We need "expanded" $daemon here, otherwise variable reference falls to .pc files 
    # FIXME: return all back to configureFlags, when placeholders would be landed.
    configureFlagsArray+=(
      "--with-bash-completion-dir=$bin/share/bash-completions/completions"
      "--with-zsh-completion-dir=$bin/share/zsh/site-functions"
      "--with-pulsedsp-location=$bin/lib/pulseaudio"
      "--with-udev-rules-dir=$daemon/lib/udev/rules.d"
      "--with-module-dir=$daemon/lib/pulseaudio"
      "--libexecdir=$daemon/libexec"
      "--datadir=$daemon/share"
    )

    # don't install proximity-helper as root and setuid
    sed -i "src/Makefile.in" \
        -e "s|chown root|true |" \
        -e "s|chmod r+s |true |"
   
    # cut-off path from default autostartable. In nixos it usually set via
    # user/system config, and I not sure if autostart still usable if pulseaudio
    # daemon used from nixpkgs on non-nixos.
    substituteInPlace src/pulse/client-conf.c --replace "PA_BINARY" "\"pulseaudio\""

    # Fixes: error: po/Makefile.in.in was not created by intltoolize.
    intltoolize --automake --copy --force

  '';

  enableParallelBuilding = true;

  # not sure what the best practices are here -- can't seem to find a way
  # for the compiler to bring in stdlib and stdio (etc.) properly
  # the alternative is to copy the files from /usr/include to src, but there are
  # probably a large number of files that would need to be copied (I stopped
  # after the seventh)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I/usr/include";

  installFlags =
    [ "sysconfdir=$(bin)/etc"
      "pulseconfdir=$(daemon)/etc/pulse"
    ];

  # FIXME: #out/share/pulse/alsa-mixer move to bin, or even to daemon (may require patch)
  # FIXME: split qpaeq to own derivation, it python script depending qt indirectly 
  #        (and w/o it fail with a message)
  postInstall = ''
    moveToOutput lib/cmake "$dev" 
    moveToOutput share/vala "$dev"
    rm $daemon/lib/systemd/user/pulseaudio.service
    for each in system.pa default.pa client.conf; do
      substituteInPlace $daemon/etc/pulse/$each --replace $bin $daemon
    done
  '';

  meta = {
    description = "Sound server for POSIX and Win32 systems";
    homepage    = http://www.pulseaudio.org/;
    license     = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 wkennington ];
    platforms   = lib.platforms.unix;

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
