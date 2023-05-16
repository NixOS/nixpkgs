{ lib
, stdenv
, fetchurl
, autoPatchelfHook
<<<<<<< HEAD
, gtk3
, zlib
, alsa-lib
, dbus
, libXcursor
, libXext
, libXi
, libXinerama
, libxkbcommon
, libXrandr
, libXScrnSaver
, libXxf86vm
, udev
, vulkan-loader # (not used by default, enable in settings menu)
, wayland # (not used by default, enable with SDL_VIDEODRIVER=wayland - doesn't support HiDPI)
, makeDesktopItem
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clonehero";
  version = "1.0.0.4080";

  src = fetchurl {
    url = "https://pubdl.clonehero.net/clonehero-v${finalAttrs.version}-final/clonehero-linux.tar.xz";
    hash = "sha256-YWLV+wgQ9RfKRSSWh/x0PMjB6tFA4YpHb9WtYOOgZZI=";
=======
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
    url = "http://dl.clonehero.net/${name}-v${lib.removePrefix "0" version}/${name}-linux.tar.gz";
    sha256 = "0k9jcnd55yhr42gj8cmysd18yldp4k3cpk4z884p2ww03fyfq7mi";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    # Load-time libraries (loaded from DT_NEEDED section in ELF binary)
<<<<<<< HEAD
    alsa-lib
    gtk3
=======
    gtk2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    stdenv.cc.cc.lib
    zlib

    # Run-time libraries (loaded with dlopen)
<<<<<<< HEAD
    dbus
    libXcursor
    libXext
    libXi
    libXinerama
    libxkbcommon
    libXrandr
    libXScrnSaver
    libXxf86vm
    udev
    vulkan-loader
    wayland
  ];

  desktopItem = makeDesktopItem {
    name = "clonehero";
    desktopName = "Clone Hero";
    comment = finalAttrs.meta.description;
    icon = "clonehero";
    exec = "clonehero";
    categories = [ "Game" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 clonehero "$out/bin/clonehero"
    install -Dm644 UnityPlayer.so "$out/libexec/clonehero/UnityPlayer.so"

    mkdir -p "$out/share/pixmaps"
    cp -r clonehero_Data "$out/share/clonehero"
    ln -s "$out/share/clonehero" "$out/bin/clonehero_Data"
    ln -s "$out/share/clonehero/Resources/UnityPlayer.png" "$out/share/pixmaps/clonehero.png"
    install -Dm644 "$desktopItem/share/applications/clonehero.desktop" "$out/share/applications/clonehero.desktop"

    mkdir -p "$doc/share/doc/clonehero"
    cp -r CLONE_HERO_MANUAL.{pdf,txt} Custom EULA.txt THIRDPARTY.txt "$doc/share/doc/clonehero"

    runHook postInstall
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # Patch required run-time libraries as load-time libraries
  #
  # Libraries found with:
<<<<<<< HEAD
  # > strings UnityPlayer.so | grep '\.so'
  # and:
  # > LD_DEBUG=libs clonehero
  postFixup = ''
    patchelf \
      --add-needed libasound.so.2 \
      --add-needed libdbus-1.so.3 \
      --add-needed libpthread.so.0 \
      --add-needed libudev.so.1 \
      --add-needed libvulkan.so.1 \
      --add-needed libwayland-client.so.0 \
      --add-needed libwayland-cursor.so.0 \
      --add-needed libwayland-egl.so.1 \
      --add-needed libX11.so.6 \
      --add-needed libXcursor.so.1 \
      --add-needed libXext.so.6 \
      --add-needed libXi.so.6 \
      --add-needed libXinerama.so.1 \
      --add-needed libxkbcommon.so.0 \
      --add-needed libXrandr.so.2 \
      --add-needed libXss.so.1 \
      --add-needed libXxf86vm.so.1 \
      "$out/libexec/clonehero/UnityPlayer.so"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Clone of Guitar Hero and Rockband-style games";
    homepage = "https://clonehero.net";
    license = licenses.unfree;
<<<<<<< HEAD
    maintainers = with maintainers; [ kira-bruneau syboxez ];
    platforms = [ "x86_64-linux" ];
  };
})
=======
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = [ "x86_64-linux" ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
