{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, alsa-lib
, gtk2
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
  version = "0.23.2.2";

  src = fetchurl {
    url = "https://pubdl.clonehero.net/clonehero-v${lib.removePrefix "0" version}/clonehero-linux.tar.gz";
    hash = "sha256-sR7svBuAc3EJQp/My8Ykt1GPQtO+MiSfIBn6UpplMk0=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
    gtk2
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
    alsa-lib # ALSA sound
    libXrandr # X11 resolution detection
    libXScrnSaver # X11 screensaver prevention
    udev # udev input drivers
  ];

  installPhase = ''
    mkdir -p "$out/bin" "$out/share"
    install -Dm755 ${name} "$out/bin"
    cp -r clonehero_Data "$out/share"

    mkdir -p "$doc/share/${name}"
    cp README.txt "$doc/share/${name}"
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
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" ];
  };
}
