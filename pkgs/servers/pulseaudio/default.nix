{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, libsndfile
, libtool
, makeWrapper
, xorg
, libcap
, alsaLib
, glib
, gnome3
, avahi
, libjack2
, libasyncns
, lirc
, dbus
, sbc
, bluez5
, udev
, openssl
, fftwFloat
, speexdsp
, systemd
, webrtc-audio-processing
, gtk3
, tdb
, orc
, soxr
, check
, gettext

, x11Support ? false

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, airtunesSupport ? false

, bluetoothSupport ? false

, remoteControlSupport ? false

, zeroconfSupport ? false

, # Whether to build only the library.
  libOnly ? false

, CoreServices
, AudioUnit
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio";
  version = "13.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "0mw0ybrqj7hvf8lqs5gjzip464hfnixw453lr0mqzlng3b5266wn";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
    ./correct-ldflags.patch
  ];

  nativeBuildInputs = [
    gettext
    makeWrapper
    meson
    ninja
    pkgconfig
  ];

  checkInputs = [
    check
  ];

  propagatedBuildInputs = lib.optional stdenv.isLinux libcap;

  buildInputs = [
    fftwFloat
    libsndfile
    libtool
    orc
    soxr
    speexdsp
    tdb
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    glib
    gtk3
    libasyncns
  ] ++ lib.optionals stdenv.isDarwin [
    AudioUnit
    Cocoa
    CoreServices
  ] ++ lib.optionals (!libOnly) (
    lib.optionals x11Support [
      xorg.libXi
      xorg.libXtst
      xorg.xlibsWrapper
    ] ++ lib.optionals stdenv.isLinux [
      alsaLib
      systemd
      udev
    ] ++ lib.optionals bluetoothSupport [
      bluez5
      sbc
    ]
    ++ lib.optional airtunesSupport openssl
    ++ lib.optional jackaudioSupport libjack2
    ++ lib.optional remoteControlSupport lirc
    ++ lib.optional zeroconfSupport avahi
    ++ [ webrtc-audio-processing ]
  );

  mesonFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Daccess_group=audio"
    "-Dbashcompletiondir=${placeholder "out"}/share/bash-completions/completions"
    "-Dman=false" # TODO: needs xmltoman; also doesn't check for this
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "-Dzshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dasyncns=disabled"
    "-Ddbus=disabled"
    "-Dglib=disabled"
    "-Dgsettings=disabled"
    "-Dgtk=disabled"
  ] ++ lib.optionals (!stdenv.isLinux || libOnly) [
    "-Dalsa=disabled"
    "-Dsystemd=disabled"
    "-Dudev=disabled"
  ] ++ lib.optional libOnly "-Dwebrtc-aec=disabled"
    ++ lib.optional (!x11Support) "-Dx11=disabled"
    ++ lib.optional (!bluetoothSupport) "-Dbluez5=false"
    ++ lib.optional (!airtunesSupport) "-Dopenssl=disabled"
    ++ lib.optional (!jackaudioSupport) "-Djack=disabled"
    ++ lib.optional (!remoteControlSupport) "-Dlirc=disabled"
    ++ lib.optional (!zeroconfSupport) "-Davahi=disabled"
    ++ lib.optional (!doCheck) "-Dtests=false";

  # To create ~/.config/pulse
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  doCheck = true;

  # not sure what the best practices are here -- can't seem to find a way
  # for the compiler to bring in stdlib and stdio (etc.) properly
  # the alternative is to copy the files from /usr/include to src, but there are
  # probably a large number of files that would need to be copied (I stopped
  # after the seventh)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I/usr/include";

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreServices -framework Cocoa -framework AudioUnit";

  postInstall = ''
    moveToOutput lib/cmake "$dev"
  '' + lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
  '';

  preFixup = lib.optionalString (stdenv.isLinux && !libOnly) ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${pname}-${version}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib gnome3.dconf}/lib/gio/modules"
  '';

  meta = with lib; {
    description = "A featureful, general-purpose sound server";
    homepage = http://www.pulseaudio.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    longDescription = ''
      PulseAudio is a sound system for POSIX OSes, meaning that it is
      a proxy for your sound applications. It allows you to do advanced
      operations on your sound data as it passes between your application
      and your hardware. Things like transferring the audio to a different machine,
      changing the sample format or channel count and mixing several sounds into one
      are easily achieved using a sound server.
    '';
  };
}
