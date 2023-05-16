<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, buildFHSEnv
=======
{ lib, stdenv, fetchurl, dpkg, makeWrapper, buildFHSEnv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, extraPkgs ? pkgs: [ ]
, extraLibs ? pkgs: [ ]
}:

stdenv.mkDerivation rec {
  pname = "unityhub";
<<<<<<< HEAD
  version = "3.5.1";

  src = fetchurl {
    url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
    sha256 = "sha256-R/Ehf379Vbh/fN6iJO6BKsUuGMe2ogJdlWosElR+7f8=";
=======
  version = "3.4.2";

  src = fetchurl {
    url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
    sha256 = "sha256-I1qtrD94IpMut0a6JUHErHaksoZ+z8/dDG8U68Y5zJE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  fhsEnv = buildFHSEnv {
    name = "${pname}-fhs-env";
    runScript = "";

    targetPkgs = pkgs: with pkgs; [
<<<<<<< HEAD
      # Unity Hub binary dependencies
      xorg.libXrandr
      xdg-utils
=======
      xorg.libXrandr
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      # GTK filepicker
      gsettings-desktop-schemas
      hicolor-icon-theme

      # Bug Reporter dependencies
      fontconfig
      freetype
      lsb-release
    ] ++ extraPkgs pkgs;

    multiPkgs = pkgs: with pkgs; [
      # Unity Hub ldd dependencies
      cups
      gtk3
      expat
      libxkbcommon
      lttng-ust_2_12
      krb5
      alsa-lib
<<<<<<< HEAD
      nss
=======
      nss_latest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      libdrm
      mesa
      nspr
      atk
      dbus
      at-spi2-core
      pango
      xorg.libXcomposite
      xorg.libXext
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libxshmfence
      xorg.libXScrnSaver
      xorg.libXtst

      # Unity Hub additional dependencies
      libva
<<<<<<< HEAD
      openssl
      cairo
=======
      openssl_1_1
      cairo
      xdg-utils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      libnotify
      libuuid
      libsecret
      udev
      libappindicator
      wayland
      cpio
      icu
      libpulseaudio

<<<<<<< HEAD
      # Unity Editor dependencies
=======
      # Editor dependencies
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      libglvnd # provides ligbl
      xorg.libX11
      xorg.libXcursor
      glib
      gdk-pixbuf
      libxml2
      zlib
      clang
      git # for git-based packages in unity package manager
<<<<<<< HEAD

      # Unity Editor 2019 specific dependencies
      xorg.libXi
      xorg.libXrender
      gnome2.GConf
      libcap
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ] ++ extraLibs pkgs;
  };

  unpackCmd = "dpkg -x $curSrc src";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv opt/ usr/share/ $out

    # `/opt/unityhub/unityhub` is a shell wrapper that runs `/opt/unityhub/unityhub-bin`
    # Which we don't need and overwrite with our own custom wrapper
    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/opt/unityhub/unityhub \
      --add-flags $out/opt/unityhub/unityhub-bin \
      --argv0 unityhub

    # Link binary
    mkdir -p $out/bin
    ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

    # Replace absolute path in desktop file to correctly point to nix store
    substituteInPlace $out/share/applications/unityhub.desktop \
      --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Official Unity3D app to download and manage Unity Projects and installations";
<<<<<<< HEAD
    homepage = "https://unity.com/";
    downloadPage = "https://unity.com/unity-hub";
    changelog = "https://unity.com/unity-hub/release-notes";
    license = licenses.unfree;
    maintainers = with maintainers; [ tesq0 huantian ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
    homepage = "https://unity3d.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ tesq0 huantian ];
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
