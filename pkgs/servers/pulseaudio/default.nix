{ lib, stdenv, fetchurl, fetchpatch, pkg-config
, libsndfile, libtool, makeWrapper, perlPackages
, xorg, libcap, alsa-lib, glib, dconf
, avahi, libjack2, libasyncns, lirc, dbus
, sbc, bluez5, udev, openssl, fftwFloat
, soxr, speexdsp, systemd, webrtc-audio-processing
, gst_all_1
, check, libintl, meson, ninja, m4, wrapGAppsHook

, x11Support ? false

, useSystemd ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, bluetoothSupport ? true
, advancedBluetoothCodecs ? false

, remoteControlSupport ? false

, zeroconfSupport ? false

, # Whether to build only the library.
  libOnly ? false

, AudioUnit, Cocoa, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio";
  version = "15.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "pAuIejupjMJpdusRvbZhOYjxRbGQJNG2VVxqA8nLoaA=";
  };

  patches = [
    # Install sysconfdir files inside of the nix store,
    # but use a conventional runtime sysconfdir outside the store
    ./add-option-for-installation-sysconfdir.patch
  ] ++ lib.optionals stdenv.isDarwin [
    # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/654
    ./0001-Make-gio-2.0-optional-when-gsettings-is-disabled.patch

    # TODO (not sent upstream)
    ./0002-Ignore-SCM_CREDS-on-macOS.patch
    ./0003-Disable-z-nodelete-on-darwin.patch
    ./0004-Prefer-clock_gettime.patch
    ./0005-Include-poll-posix.c-on-darwin.patch
    ./0006-Only-use-version-script-on-GNU-ish-linkers.patch
    ./0007-Adapt-undefined-link-args-per-linker.patch
    ./0008-Use-correct-semaphore-on-darwin.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config meson ninja makeWrapper perlPackages.perl perlPackages.XMLParser m4 ]
    ++ lib.optionals stdenv.isLinux [ glib ]
    # gstreamer plugin discovery requires wrapping
    ++ lib.optional (bluetoothSupport && advancedBluetoothCodecs) wrapGAppsHook;

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ libtool libsndfile soxr speexdsp fftwFloat check ]
    ++ lib.optionals stdenv.isLinux [ glib dbus ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit Cocoa CoreServices libintl ]
    ++ lib.optionals (!libOnly) (
      [ libasyncns webrtc-audio-processing ]
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optionals x11Support [ xorg.xlibsWrapper xorg.libXtst xorg.libXi ]
      ++ lib.optional useSystemd systemd
      ++ lib.optionals stdenv.isLinux [ alsa-lib udev ]
      ++ lib.optional airtunesSupport openssl
      ++ lib.optionals bluetoothSupport [ bluez5 sbc ]
      # aptX and LDAC codecs are in gst-plugins-bad so far, rtpldacpay is in -good
      ++ lib.optionals (bluetoothSupport && advancedBluetoothCodecs) (builtins.attrValues { inherit (gst_all_1) gst-plugins-bad gst-plugins-good gst-plugins-base gstreamer; })
      ++ lib.optional remoteControlSupport lirc
      ++ lib.optional zeroconfSupport  avahi
  );

  mesonFlags = [
    "-Dalsa=${if !libOnly then "enabled" else "disabled"}"
    "-Dasyncns=${if !libOnly then "enabled" else "disabled"}"
    "-Davahi=${if zeroconfSupport then "enabled" else "disabled"}"
    "-Dbluez5=${if !libOnly && bluetoothSupport then "enabled" else "disabled"}"
    # advanced bluetooth audio codecs are provided by gstreamer
    "-Dbluez5-gstreamer=${if (!libOnly && bluetoothSupport && advancedBluetoothCodecs) then "enabled" else "disabled"}"
    "-Ddatabase=simple"
    "-Ddoxygen=false"
    "-Delogind=disabled"
    # gsettings does not support cross-compilation
    "-Dgsettings=${if stdenv.isLinux && (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dgstreamer=disabled"
    "-Dgtk=disabled"
    "-Djack=${if jackaudioSupport && !libOnly then "enabled" else "disabled"}"
    "-Dlirc=${if remoteControlSupport then "enabled" else "disabled"}"
    "-Dopenssl=${if airtunesSupport then "enabled" else "disabled"}"
    "-Dorc=disabled"
    "-Dsystemd=${if useSystemd && !libOnly then "enabled" else "disabled"}"
    "-Dtcpwrap=disabled"
    "-Dudev=${if !libOnly then "enabled" else "disabled"}"
    "-Dvalgrind=disabled"
    "-Dwebrtc-aec=${if !libOnly then "enabled" else "disabled"}"
    "-Dx11=${if x11Support then "enabled" else "disabled"}"

    "-Dlocalstatedir=/var"
    "-Dsysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
  ]
  ++ lib.optional (stdenv.isLinux && useSystemd) "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ++ lib.optionals (stdenv.isDarwin) [
    "-Ddbus=disabled"
    "-Dglib=disabled"
    "-Doss-output=disabled"
  ];

  # tests fail on Darwin because of timeouts
  doCheck = !stdenv.isDarwin;
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString libOnly ''
    find $out/share -maxdepth 1 -mindepth 1 ! -name "vala" -prune -exec rm -r {} \;
    find $out/share/vala -maxdepth 1 -mindepth 1 ! -name "vapi" -prune -exec rm -r {} \;
    rm -r $out/{bin,etc,lib/pulse-*}
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
