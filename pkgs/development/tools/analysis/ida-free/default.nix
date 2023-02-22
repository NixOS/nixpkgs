{ lib
, stdenv
, fetchurl
, libGL
, zlib
, libkrb5
, libsecret
, libunwind
, libxkbcommon
, glib
, makeWrapper
, openssl
, xorg
, dbus
, fontconfig
, freetype
, makeDesktopItem
}:


let
  srcs = builtins.fromJSON (builtins.readFile ./srcs.json);
in

stdenv.mkDerivation rec {
  pname = "ida-free";
  version = "8.2.230124";

  src = fetchurl {
    inherit (srcs.${stdenv.system}) url sha256;
  };

  icon = fetchurl {
    urls = [
      "https://www.hex-rays.com/products/ida/news/8_1/images/icon_free.png"
      "https://web.archive.org/web/20221105181231if_/https://hex-rays.com/products/ida/news/8_1/images/icon_free.png"
    ];
    sha256 = "sha256-widkv2VGh+eOauUK/6Sz/e2auCNFAsc8n9z0fdrSnW0=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "ida64";
    icon = icon;
    comment = "Freeware version of the world's smartest and most feature-full disassembler";
    desktopName = "IDA Free";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
  };

  ldLibraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    zlib
    glib
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    xorg.libXau
    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libXext
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    libkrb5
    libsecret
    libunwind
    libxkbcommon
    openssl
    dbus
    fontconfig
    freetype
    libGL
  ];

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    IDADIR=$out/opt/${pname}

    install -d $IDADIR $out/bin $out/share/applications

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) ${src} \
      --mode unattended --prefix $IDADIR --installpassword ""

    rm $IDADIR/[Uu]ninstall*

    for bb in ida64 assistant; do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $IDADIR/$bb
      wrapProgram \
        $IDADIR/$bb \
        --set LD_LIBRARY_PATH "$IDADIR:${ldLibraryPath}" \
        --set QT_PLUGIN_PATH "$IDADIR/plugins/platforms"
    done

    ln -s $IDADIR/ida64 $out/bin/ida64

    cp $desktopItem/share/applications/* $out/share/applications

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Freeware version of the world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-free/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ lourkeur ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "ida64";
  };
}
