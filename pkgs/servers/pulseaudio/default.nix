{ lib, stdenv, fetchurl, pkgconfig, intltool, autoreconfHook
, libsndfile, libtool, makeWrapper
, xorg, libcap, alsaLib, glib, gnome3
, avahi, libjack2, libasyncns, lirc, dbus
, sbc, bluez5, udev, openssl, fftwFloat
, speexdsp, systemd, webrtc-audio-processing

, x11Support ? false

, useSystemd ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, bluetoothSupport ? false

, remoteControlSupport ? false

, zeroconfSupport ? false

, # Whether to build only the library.
  libOnly ? false

, CoreServices, AudioUnit, Cocoa
}:

stdenv.mkDerivation rec {
  name = "${if libOnly then "lib" else ""}pulseaudio-${version}";
  version = "12.2";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "0ma0p8iry7fil7qb4pm2nx2pm65kq9hk9xc4r5wkf14nqbzni5l0";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool autoreconfHook makeWrapper ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ libtool libsndfile speexdsp fftwFloat ]
    ++ lib.optionals stdenv.isLinux [ glib dbus ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices AudioUnit Cocoa ]
    ++ lib.optionals (!libOnly) (
      [ libasyncns webrtc-audio-processing ]
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optionals x11Support [ xorg.xlibsWrapper xorg.libXtst xorg.libXi ]
      ++ lib.optional useSystemd systemd
      ++ lib.optionals stdenv.isLinux [ alsaLib udev ]
      ++ lib.optional airtunesSupport openssl
      ++ lib.optionals bluetoothSupport [ bluez5 sbc ]
      ++ lib.optional remoteControlSupport lirc
      ++ lib.optional zeroconfSupport  avahi
    );

  preConfigure = ''
    # Performs and autoreconf
    export NOCONFIGURE="yes"
    patchShebangs bootstrap.sh
    ./bootstrap.sh

    # Move the udev rules under $(prefix).
    sed -i "src/Makefile.in" \
        -e "s|udevrulesdir[[:blank:]]*=.*$|udevrulesdir = $out/lib/udev/rules.d|g"

    # don't install proximity-helper as root and setuid
    sed -i "src/Makefile.in" \
        -e "s|chown root|true |" \
        -e "s|chmod r+s |true |"
  '';

  configureFlags =
    [ "--disable-solaris"
      "--disable-jack"
      "--disable-oss-output"
    ] ++ lib.optional (!ossWrapper) "--disable-oss-wrapper" ++
    [ "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-access-group=audio"
      "--with-bash-completion-dir=\${out}/share/bash-completions/completions"
    ]
    ++ lib.optional (jackaudioSupport && !libOnly) "--enable-jack"
    ++ lib.optional stdenv.isDarwin "--with-mac-sysroot=/"
    ++ lib.optional (stdenv.isLinux && useSystemd) "--with-systemduserunitdir=\${out}/lib/systemd/user";

  enableParallelBuilding = true;

  # not sure what the best practices are here -- can't seem to find a way
  # for the compiler to bring in stdlib and stdio (etc.) properly
  # the alternative is to copy the files from /usr/include to src, but there are
  # probably a large number of files that would need to be copied (I stopped
  # after the seventh)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I/usr/include";

  installFlags =
    [ "sysconfdir=$(out)/etc"
      "pulseconfdir=$(out)/etc/pulse"
    ];

  postInstall = lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
    sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $out/lib/pulseaudio/libpulsecore-${version}.la
  ''
    + ''moveToOutput lib/cmake "$dev" '';

  preFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${name}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib gnome3.dconf}/lib/gio/modules"
  '';

  meta = {
    description = "Sound server for POSIX and Win32 systems";
    homepage    = http://www.pulseaudio.org/;
    license     = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
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
