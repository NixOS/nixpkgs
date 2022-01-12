{ lib
, stdenv
, openjdk8
, buildFHSUserEnv
, fetchzip
, fetchurl
, copyDesktopItems
, makeDesktopItem
}:
let
  version = "2.839";
  src = stdenv.mkDerivation {
    pname = "tlauncher";
    inherit version;
    src = fetchzip {
      name = "tlauncher.zip";
      url = "https://dl2.tlauncher.org/f.php?f=files%2FTLauncher-${version}.zip";
      sha256 = "sha256-KphpNuTucpuJhXspKxqDyYQN6vbpY0XCB3GAd5YCGbc=";
      stripRoot = false;
    };
    installPhase = ''
      cp $src/*.jar $out
    '';
  };
  fhs = buildFHSUserEnv {
    name = "tlauncher";
    runScript = ''
      ${openjdk8}/bin/java -jar "${src}" "$@"
    '';
    targetPkgs = pkgs: with pkgs; [
      alsa-lib
      cpio
      cups
      file
      fontconfig
      freetype
      giflib
      glib
      gnome2.GConf
      gnome2.gnome_vfs
      gtk2
      libjpeg
      libGL
      openjdk8-bootstrap
      perl
      which
      xorg.libICE
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.xrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXtst
      xorg.libXxf86vm
      zip
      zlib
    ];
  };
  desktopItem = makeDesktopItem {
    name = "tlauncher";
    exec = "tlauncher";
    icon = fetchurl {
      url = "https://styles.redditmedia.com/t5_2o8oax/styles/communityIcon_gu5r5v8eaiq51.png";
      sha256 = "sha256-ma8zxaUxdAw5VYfOK8i8s1kjwMgs80Eomq43Cb0HZWw=";
    };
    comment = "Minecraft launcher";
    desktopName = "TLauncher";
    categories = "Game;";
  };
in stdenv.mkDerivation {
  pname = "tlauncher-wrapper";
  inherit version;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out/{bin,share/applications} -p
    install ${fhs}/bin/tlauncher $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [ desktopItem ];

  meta = with lib; {
    description = "Minecraft launcher that already deal with forge, optifine and mods";
    homepage = "https://tlauncher.org/";
    maintainers = with maintainers; [ lucasew ];
    license = licenses.unfree;
    platforms = openjdk8.meta.platforms;
  };
}
