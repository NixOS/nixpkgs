{ lib, stdenv, fetchurl, fetchpatch, pkg-config
, libsndfile, libtool, makeWrapper, perlPackages
, xorg, libcap, alsa-lib, glib, dconf
, avahi, libjack2, libasyncns, lirc, dbus
, sbc, bluez5, udev, openssl, fftwFloat
, soxr, speexdsp, systemd, webrtc-audio-processing
, gst_all_1
, check, libintl, meson, ninja, m4, wrapGAppsHook

, x11Support ? false

, useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, bluetoothSupport ? stdenv.isLinux
, advancedBluetoothCodecs ? false

, remoteControlSupport ? false

, zeroconfSupport ? false

, alsaSupport ? stdenv.isLinux
, udevSupport ? stdenv.isLinux

, # Whether to build only the library.
  libOnly ? false

, AudioUnit, Cocoa, CoreServices, CoreAudio
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio";
  version = "16.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "sha256-ju8yzpHUeXn5X9mpNec4zX63RjQw2rxyhjJRdR5QSuQ=";
  };

  patches = [
    # Install sysconfdir files inside of the nix store,
    # but use a conventional runtime sysconfdir outside the store
    ./add-option-for-installation-sysconfdir.patch
    # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/654 (merged)
    ./0001-Make-gio-2.0-optional-16.patch
    # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/merge_requests/746 (merged)
    ./0002-Ignore-SCM_CREDS-on-darwin.patch
    ./0003-Ignore-HAVE_CPUID_H-on-aarch64-darwin.patch
    ./0004-Prefer-HAVE_CLOCK_GETTIME-on-darwin.patch
    ./0005-Enable-CoreAudio-on-darwin.patch
    ./0006-Fix-libpulsecommon-sources-on-darwin.patch
    ./0007-Fix-link-args-on-darwin.patch
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
    ++ lib.optionals stdenv.isDarwin [ AudioUnit Cocoa CoreServices CoreAudio libintl ]
    ++ lib.optionals (!libOnly) (
      [ libasyncns webrtc-audio-processing ]
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optionals x11Support [ xorg.libICE xorg.libSM xorg.libX11 xorg.libXi xorg.libXtst ]
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
    "-Dalsa=${if !libOnly && alsaSupport then "enabled" else "disabled"}"
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
    "-Dudev=${if !libOnly && udevSupport then "enabled" else "disabled"}"
    "-Dvalgrind=disabled"
    "-Dwebrtc-aec=${if !libOnly then "enabled" else "disabled"}"
    "-Dx11=${if x11Support then "enabled" else "disabled"}"

    "-Dlocalstatedir=/var"
    "-Dsysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"

    # pulseaudio complains if its binary is moved after installation;
    # this is needed so that wrapGApp can operate *without*
    # renaming the unwrapped binaries (see below)
    "--bindir=${placeholder "out"}/.bin-unwrapped"
  ]
  ++ lib.optional (stdenv.isLinux && useSystemd) "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ++ lib.optionals stdenv.isDarwin [
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
    rm -r $out/{.bin-unwrapped,etc,lib/pulse-*}
  ''
    + ''
    moveToOutput lib/cmake "$dev"
    rm -f $out/.bin-unwrapped/qpaeq # this is packaged by the "qpaeq" package now, because of missing deps
  '';

  preFixup = lib.optionalString (stdenv.isLinux  && (stdenv.hostPlatform == stdenv.buildPlatform)) ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${pname}-${version}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  ''
  # add .so symlinks for modules to be found under macOS
  + lib.optionalString stdenv.isDarwin ''
    for file in $out/lib/pulseaudio/modules/*.dylib; do
      ln -s "''$file" "''${file%.dylib}.so"
      ln -s "''$file" "$out/lib/pulseaudio/''$(basename ''$file .dylib).so"
    done
  ''
  # put symlinks to binaries in `$prefix/bin`;
  # then wrapGApp will *rename these symlinks* instead of
  # the original binaries in `$prefix/.bin-unwrapped` (see above);
  # when pulseaudio is looking for its own binary (it does!),
  # it will be happy to find it in its original installation location
  + lib.optionalString (!libOnly) ''
    mkdir -p $out/bin
    ln -st $out/bin $out/.bin-unwrapped/*

    # Ensure that service files use the wrapped binaries.
    find "$out" -name "*.service" | while read f; do
        substituteInPlace "$f" --replace "$out/.bin-unwrapped/" "$out/bin/"
    done
  '';

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
