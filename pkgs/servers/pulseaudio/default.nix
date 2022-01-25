{ lib, stdenv, fetchurl, pkg-config, autoreconfHook
, libsndfile, libtool, makeWrapper, perlPackages
, xorg, libcap, alsa-lib, glib, dconf
, avahi, libjack2, libasyncns, lirc, dbus
, sbc, bluez5, udev, openssl, fftwFloat
, soxr, speexdsp, systemd, webrtc-audio-processing

, x11Support ? false

, useSystemd ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, bluetoothSupport ? true

, remoteControlSupport ? false

, zeroconfSupport ? false

, # Whether to build only the library.
  libOnly ? false

, AudioUnit, Cocoa, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio";
  version = "14.2";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "sha256-ddP3dCwa5EkEmkyIkA5FS4s1DsqoxUTzSIolYqn/ZvE=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook makeWrapper perlPackages.perl perlPackages.XMLParser ]
    ++ lib.optionals stdenv.isLinux [ glib ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ libtool libsndfile soxr speexdsp fftwFloat ]
    ++ lib.optionals stdenv.isLinux [ glib dbus ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit Cocoa CoreServices ]
    ++ lib.optionals (!libOnly) (
      [ libasyncns webrtc-audio-processing ]
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optionals x11Support [ xorg.xlibsWrapper xorg.libXtst xorg.libXi ]
      ++ lib.optional useSystemd systemd
      ++ lib.optionals stdenv.isLinux [ alsa-lib udev ]
      ++ lib.optional airtunesSupport openssl
      ++ lib.optionals bluetoothSupport [ bluez5 sbc ]
      ++ lib.optional remoteControlSupport lirc
      ++ lib.optional zeroconfSupport  avahi
  );

  prePatch = ''
    substituteInPlace bootstrap.sh \
      --replace pkg-config $PKG_CONFIG
  '';

  autoreconfPhase = ''
    # Performs an autoreconf
    patchShebangs bootstrap.sh
    NOCONFIGURE=1 ./bootstrap.sh

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
      "--with-bash-completion-dir=${placeholder "out"}/share/bash-completions/completions"
    ]
    ++ lib.optional (jackaudioSupport && !libOnly) "--enable-jack"
    ++ lib.optionals stdenv.isDarwin [
      "--disable-neon-opt"
    ]
    ++ lib.optional (stdenv.isLinux && useSystemd) "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--disable-gsettings";

  enableParallelBuilding = true;

  installFlags =
    [ "sysconfdir=${placeholder "out"}/etc"
      "pulseconfdir=${placeholder "out"}/etc/pulse"
    ];

  postInstall = lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
    sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $out/lib/pulseaudio/libpulsecore-${version}.la
  ''
    + ''
    moveToOutput lib/cmake "$dev"
    rm -f $out/bin/qpaeq # this is packaged by the "qpaeq" package now, because of missing deps
  '';

  preFixup = lib.optionalString (stdenv.isLinux  && (stdenv.hostPlatform == stdenv.buildPlatform)) ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${pname}-${version}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  passthru = {
    pulseDir = "lib/pulse-" + lib.versions.majorMinor version;
  };

  meta = {
    description = "Sound server for POSIX and Win32 systems";
    homepage    = "http://www.pulseaudio.org/";
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
