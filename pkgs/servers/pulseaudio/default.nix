{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, intltool, autoreconfHook
, libsndfile, libtool
, xorg, libcap, alsaLib, glib
, avahi, libjack2, libasyncns, lirc, dbus
, sbc, bluez5, udev, openssl, fftwFloat
, speexdsp, systemd, webrtc-audio-processing, gconf ? null

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

, # Whether to build only the library.
  libOnly ? false

, CoreServices, AudioUnit, Cocoa
}:

stdenv.mkDerivation rec {
  name = "${if libOnly then "lib" else ""}pulseaudio-${version}";
  version = "11.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "17ndr6kc7hpv4ih4gygwlcpviqifbkvnk4fbwf4n25kpb991qlpj";
  };

  patches = [ ./caps-fix.patch (fetchpatch {
    name = "glibc-2.27.patch";
    url = "https://cgit.freedesktop.org/pulseaudio/pulseaudio/patch/?id=dfb0460fb4743aec047cdf755a660a9ac2d0f3fb";
    sha256 = "1bi6rbfdjyl6wn0jql4k18xa4hm5l2lpf1sc5j77f8l6jw956afv";
  }) ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      name = "padsp-fix.patch";
      url = "https://git.alpinelinux.org/cgit/aports/plain/testing/pulseaudio/0001-padsp-Make-it-compile-on-musl.patch?id=167be02bf4618a90328e2b234f6a63a5dc05f244";
      sha256 = "0gf4w25zi123ghk0njapysvrlljkc3hyanacgiswfnnm1i8sab1q";
    });

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig intltool autoreconfHook ];

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
      ++ lib.optional gconfSupport gconf
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
