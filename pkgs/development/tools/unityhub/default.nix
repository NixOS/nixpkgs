{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  buildFHSEnv,
  extraPkgs ? pkgs: [ ],
  extraLibs ? pkgs: [ ],
}:

stdenv.mkDerivation rec {
  pname = "unityhub";
  version = "3.8.0";

  src = fetchurl {
    url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
    sha256 = "sha256-TjuOsF4LFqQGx4j5j/Er97MNhVm72qlvGYZvA5vuXs8=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  fhsEnv = buildFHSEnv {
    name = "${pname}-fhs-env";
    runScript = "";

    targetPkgs =
      pkgs:
      with pkgs;
      [
        # Unity Hub binary dependencies
        xorg.libXrandr
        xdg-utils

        # GTK filepicker
        gsettings-desktop-schemas
        hicolor-icon-theme

        # Bug Reporter dependencies
        fontconfig
        freetype
        lsb-release
      ]
      ++ extraPkgs pkgs;

    multiPkgs =
      pkgs:
      with pkgs;
      [
        # Unity Hub ldd dependencies
        cups
        gtk3
        expat
        libxkbcommon
        lttng-ust_2_12
        krb5
        alsa-lib
        nss
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
        openssl
        cairo
        libnotify
        libuuid
        libsecret
        udev
        libappindicator
        wayland
        cpio
        icu
        libpulseaudio

        # Unity Editor dependencies
        libglvnd # provides ligbl
        xorg.libX11
        xorg.libXcursor
        glib
        gdk-pixbuf
        libxml2
        zlib
        clang
        git # for git-based packages in unity package manager

        # Unity Editor 2019 specific dependencies
        xorg.libXi
        xorg.libXrender
        gnome2.GConf
        libcap
      ]
      ++ extraLibs pkgs;
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
    homepage = "https://unity.com/";
    downloadPage = "https://unity.com/unity-hub";
    changelog = "https://unity.com/unity-hub/release-notes";
    license = licenses.unfree;
    maintainers = with maintainers; [
      tesq0
      huantian
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
