{ lib
, stdenv
, fetchurl
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libsndfile
, libtool
, makeWrapper
, perlPackages
, xorg
, libcap
, alsa-lib
, glib
, dconf
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
, soxr
, speexdsp
, systemd
, webrtc-audio-processing
, gtk3
, tdb
, orc
, check
, gettext
, gst_all_1
, libopenaptx

, x11Support ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, airtunesSupport ? true

, bluetoothSupport ? true

, remoteControlSupport ? true

, zeroconfSupport ? true

, # Whether to build only the library.
  libOnly ? false

# Building from Git source
, fromGit ? true

, CoreServices
, AudioUnit
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio-hsphfpd";
  version = "13.99.2";

  outputs = [ "out" "dev" ];

  # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/288
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pali";
    repo = "pulseaudio";
    rev = "5336b39e7e03cf50386e719e287a712b59730eb8";
    sha256 = "0vc0i5rzkns3xw6y2q0c94p2qdi5k3mgjvhicgq1b0py2qxmji16";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
    ./correct-ldflags.patch
  ];

  # Says it should be v${version} but it's parsing logic is broken
  preConfigure = lib.optionalString fromGit ''
    sed -i "s@version : run_command.*@version: '${version}',@" meson.build
  '';

  nativeBuildInputs = [
    gettext
    makeWrapper
    meson
    ninja
    pkg-config
    perlPackages.perl
    perlPackages.XMLParser
  ];

  checkInputs = [
    check
  ];

  propagatedBuildInputs = lib.optional stdenv.isLinux libcap;

  buildInputs = [
    libopenaptx
    fftwFloat
    libsndfile
    libtool
    orc
    soxr
    speexdsp
    tdb
    sbc
    gst_all_1.gst-plugins-base
  ] ++ lib.optionals bluetoothSupport [
    bluez5
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
      alsa-lib
      systemd
      udev
    ] ++ lib.optional airtunesSupport openssl
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
    rm -f $out/bin/qpaeq # this is packaged by the "qpaeq" package now, because of missing deps
  '' + lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
  '';

  preFixup = lib.optionalString (stdenv.isLinux && !libOnly) ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${pname}-${version}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  passthru = {
    pulseDir = "lib/pulse-" + lib.versions.majorMinor version;
  };

  meta = with lib; {
    description = "A featureful, general-purpose sound server";
    homepage = "http://www.pulseaudio.org/";
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
