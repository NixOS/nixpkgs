{ stdenv, requireFile, unzip, makeDesktopItem, SDL2, xorg, libpulseaudio, systemd }:

let
  arch = if stdenv.system == "x86_64-linux"
    then "amd64"
    else "i386";

  sha = if stdenv.system == "x86_64-linux"
    then "9925ad06770a71854b1fee7dc6c69ca0760565ad5f3c0c8d11500f7ad39a445d"
    else "d83062db0a2df78799ebe590593a215b470a27b834fb71a54052b65217add7af";

  desktopItem = makeDesktopItem {
    desktopName = "pico-8";
    genericName = "pico-8 virtual console";
    categories = "Game;";
    exec = "pico8";
    icon = "lexaloffle-pico8";
    name = "pico8";
    type = "Application";
  };

in

stdenv.mkDerivation rec {
  pname = "pico-8";
  version = "0.2.0i";

  helpMsg = ''
    We cannot download the full version automatically, as you require a license.
    Once you have bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://\$PWD/${pname}_${version}_${arch}.zip"
    in the directory where you saved it.
  '';

  src = requireFile {
    message = helpMsg;
    name = "${pname}_${version}_${arch}.zip";
    sha256 = sha;
  };

  buildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib stdenv.cc.libc SDL2
    xorg.libX11 xorg.libXinerama libpulseaudio ];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/applications $out/share/icons/hicolor/128x128/apps

    install -t $out/bin -m755 -v pico8 
    install -t $out/bin -m644 pico8.dat
    install -t $out/share/icons/hicolor/128x128/apps -m644 lexaloffle-pico8.png

    cp ${desktopItem}/share/applications/pico8.desktop \
      $out/share/applications/pico8.desktop

    ln -s ${systemd.lib}/lib/libudev.so.1 $out/lib/libudev.so.1

    patchelf \
      --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${libPath}:$out/lib \
      $out/bin/pico8
  '';

  meta = with stdenv.lib; {
    description = "Tiny 2D, 4-bit colour fantasy console.";
    homepage = "https://www.lexaloffle.com/pico-8.php";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ maxeaubrey ];
  };
}

