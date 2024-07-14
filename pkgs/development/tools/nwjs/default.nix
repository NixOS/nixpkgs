{ alsa-lib
, at-spi2-core
, atk
, autoPatchelfHook
, buildEnv
, cairo
, cups
, dbus
, expat
, fetchurl
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, lib
, libcap
, libdrm
, libGL
, libnotify
, libuuid
, libxcb
, libxkbcommon
, makeWrapper
, mesa
, nspr
, nss
, pango
, sdk ? false
, sqlite
, stdenv
, systemd
, udev
, wrapGAppsHook3
, xorg
, unzip
}:

let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64" else if stdenv.hostPlatform.system == "aarch64-darwin" then "arm64" else "ia32";
  os = if stdenv.hostPlatform.system == "aarch64-darwin" then "osx" else "linux";
  dlextension = if stdenv.hostPlatform.system == "aarch64-darwin" then "zip" else "tar.gz";
  flavor = if sdk then "sdk-" else "";

  nwEnvPaths = if os != "osx" then [
    alsa-lib
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libcap
    libdrm
    libGL
    libnotify
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxshmfence
    # libnw-specific (not chromium dependencies)
    ffmpeg
    libxcb
    # chromium runtime deps (dlopen’d)
    libuuid
    sqlite
    udev
  ] else [
    # libnw-specific (not chromium dependencies)
    ffmpeg
    libxcb
  ];

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = nwEnvPaths;
    extraOutputsToInstall = [ "lib" "out" ];
  };

  version = "0.89.0";
in
stdenv.mkDerivation {
  pname = "nwjs";
  inherit version;

  src =
      fetchurl {
        url = "https://dl.nwjs.io/v${version}/nwjs-${flavor}v${version}-${os}-${bits}.${dlextension}";
        hash = {
          "sdk-ia32" = "sha256-pk8Fdzw8zBBF4xeU5BlmkF1gbf7HIn8jheSjbdV4hI0=";
          "sdk-x64" = "sha256-51alZRf/+bpKfVLUQuy1VtLHCgkVuptQaJgupt7zxcU=";
          "sdk-arm64" = "sha256-qTJWYA074PHIEOqTNZX1kHQWfnP1fU0snxIf0NzTjvY=";
          "ia32" = "sha256-OLkOJo3xDZ6WKbf6zPeY+KcgzoEjYWMIV7YWWbESjPo=";
          "x64" = "sha256-KSsaTs0W8m2dI+0ByLqU4H4ai/PXUt6LtroZIBeymgs=";
          "arm64" = "sha256-W6Dul8NsxkeaLP4OAswha5UGIpgM5/cSyPBLk4djoIU=";
        }."${flavor + bits}";
      };

  nativeBuildInputs = if stdenv.isDarwin then [] else [  autoPatchelfHook (wrapGAppsHook3.override { inherit makeWrapper; }) ];
  buildInputs = if os != "osx" then [ nwEnv ] else [ unzip  ffmpeg libxcb ];
  appendRunpaths = if os != "osx" then map (pkg: (lib.getLib pkg) + "/lib") [ nwEnv stdenv.cc.libc stdenv.cc.cc ] else [];

  preFixup = ''
    if [ "${os}" = "osx" ]; then
      # Flags for OSX
      gappsWrapperArgs+=(
          --add-flags "--ozone-platform-hint=auto"
        )
    else
      gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    )
    fi
  '';

  unpackPhase = ''
    if [ "${os}" = "osx" ]; then
      mkdir -p $out
      unzip $src -d $out
    else
      runHook unpackPhase
    fi
  '';

  installPhase = ''
      runHook preInstall

      if [ "${os}" = "osx" ]; then
        echo "OSX build..."
      else
        mkdir -p $out/share/nwjs
        cp -R * $out/share/nwjs
        find $out/share/nwjs
        mkdir -p $out/bin
        create_symlink() {
            ln -s $(lib.getLib systemd)/lib/libudev.so $out/share/nwjs/libudev.so.0
        }
        create_symlink
        ln -s $out/share/nwjs/nw $out/bin
        mkdir $out/lib
        ln -s $out/share/nwjs/lib/libnw.so $out/lib/libnw.so
      fi
      runHook postInstall
  '';

  meta = with lib; {
    description = "App runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = [ maintainers.mikaelfangel ];
    mainProgram = "nw";
    license = licenses.bsd3;
  };
}
