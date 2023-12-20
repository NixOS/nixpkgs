{ lib
, stdenv
, libXScrnSaver
, makeWrapper
, fetchurl
, wrapGAppsHook
, glib
, gtk3
, unzip
, at-spi2-atk
, libdrm
, mesa
, libxkbcommon
, libxshmfence
, libglvnd
, alsa-lib
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, nss
, nspr
, xorg
, pango
, systemd
, pciutils
}:

version: hashes:
let
  pname = "electron";

  meta = with lib; {
    description = "Cross platform desktop application shell";
    homepage = "https://github.com/electron/electron";
    license = licenses.mit;
    maintainers = with maintainers; [ travisbhartwell manveru prusnak ];
    mainProgram = "electron";
    platforms = [ "x86_64-darwin" "x86_64-linux" "armv7l-linux" "aarch64-linux" ]
      ++ optionals (versionAtLeast version "11.0.0") [ "aarch64-darwin" ]
      ++ optionals (versionOlder version "19.0.0") [ "i686-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    knownVulnerabilities = optional (versionOlder version "26.0.0") "Electron version ${version} is EOL";
  };

  fetcher = vers: tag: hash: fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${vers}/electron-v${vers}-${tag}.zip";
    sha256 = hash;
  };

  headersFetcher = vers: hash: fetchurl {
    url = "https://artifacts.electronjs.org/headers/dist/v${vers}/node-v${vers}-headers.tar.gz";
    sha256 = hash;
  };

  tags = {
    x86_64-linux = "linux-x64";
    armv7l-linux = "linux-armv7l";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
  } // lib.optionalAttrs (lib.versionAtLeast version "11.0.0") {
     aarch64-darwin = "darwin-arm64";
  } // lib.optionalAttrs (lib.versionOlder version "19.0.0") {
    i686-linux = "linux-ia32";
  };

  get = as: platform: as.${platform.system} or (throw "Unsupported system: ${platform.system}");

  common = platform: {
    inherit pname version meta;
    src = fetcher version (get tags platform) (get hashes platform);
    passthru.headers = headersFetcher version hashes.headers;
  };

  electronLibPath = lib.makeLibraryPath ([
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    nss
    nspr
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxkbfile
    pango
    pciutils
    stdenv.cc.cc.lib
    systemd
  ]
    ++ lib.optionals (lib.versionAtLeast version "9.0.0") [ libdrm mesa ]
    ++ lib.optionals (lib.versionOlder version "10.0.0") [ libXScrnSaver ]
    ++ lib.optionals (lib.versionAtLeast version "11.0.0") [ libxkbcommon ]
    ++ lib.optionals (lib.versionAtLeast version "12.0.0") [ libxshmfence ]
    ++ lib.optionals (lib.versionAtLeast version "17.0.0") [ libglvnd ]
  );

  linux = {
    buildInputs = [ glib gtk3 ];

    nativeBuildInputs = [
      unzip
      makeWrapper
      wrapGAppsHook
    ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/libexec/electron $out/bin
      unzip -d $out/libexec/electron $src
      ln -s $out/libexec/electron/electron $out/bin
      chmod u-x $out/libexec/electron/*.so*
    '';

    postFixup = ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${electronLibPath}:$out/libexec/electron" \
        $out/libexec/electron/.electron-wrapped \
        ${lib.optionalString (lib.versionAtLeast version "15.0.0") "$out/libexec/electron/.chrome_crashpad_handler-wrapped" }
    '';
  };

  darwin = {
    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      makeWrapper $out/Applications/Electron.app/Contents/MacOS/Electron $out/bin/electron
    '';
  };
in
  stdenv.mkDerivation (
    (common stdenv.hostPlatform) //
    (if stdenv.isDarwin then darwin else linux)
  )
