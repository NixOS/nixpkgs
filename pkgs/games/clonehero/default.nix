{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, alsa-lib
, gtk3
, libXrandr
, libXScrnSaver
, udev
, zlib
}:

let
  name = "clonehero";
in
stdenv.mkDerivation rec {
  pname = "${name}-unwrapped";
  version = "1.0.0.4080";

  src = fetchurl {
    url = "http://pubdl.clonehero.net/${name}-v${lib.removePrefix "0" version}-final/${name}-linux.tar.xz";
    hash = "sha256-YWLV+wgQ9RfKRSSWh/x0PMjB6tFA4YpHb9WtYOOgZZI=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    gtk3
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    alsa-lib # ALSA sound
    libXrandr # X11 resolution detection
    libXScrnSaver # X11 screensaver prevention
    udev # udev input drivers
  ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/share" "$out/lib"
    install -Dm755 ${name} "$out/bin"
    install -Dm644 UnityPlayer.so "$out/lib"
    cp -r clonehero_Data "$out/share"

    mkdir -p "$doc/share/${name}"
    cp CLONE_HERO_MANUAL.txt "$doc/share/${name}"
    cp EULA.txt "$doc/share/${name}"
    cp THIRDPARTY.txt "$doc/share/${name}"
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
  # > strings clonehero | grep '\.so'
  # and
  # > strace clonehero 2>&1 | grep '\.so'
  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libudev.so.1 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      "$out/bin/${name}"
  '';

  meta = with lib; {
    description = "Clone of Guitar Hero and Rockband-style games";
    homepage = "https://clonehero.net";
    license = licenses.unfree;
    maintainers = with maintainers; [ kira-bruneau syboxez ];
    platforms = [ "x86_64-linux" ];
  };
}
