{ lib, stdenv
, libXScrnSaver
, makeWrapper
, fetchurl
, wrapGAppsHook
, glib
, gtk3
, unzip
, atomEnv
, libuuid
, at-spi2-atk
, at-spi2-core
, libdrm
, mesa
, libxkbcommon
, libappindicator-gtk3
, libxshmfence
, libglvnd
}:

version: hashes:
let
  pname = "electron";

  meta = with lib; {
    description = "Cross platform desktop application shell";
    homepage = "https://github.com/electron/electron";
    license = licenses.mit;
    maintainers = with maintainers; [ travisbhartwell manveru prusnak ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ]
      ++ optionals (versionAtLeast version "11.0.0") [ "aarch64-darwin" ];
    knownVulnerabilities = optional (versionOlder version "14.0.0") "Electron version ${version} is EOL";
  };

  fetcher = vers: tag: hash: fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${vers}/electron-v${vers}-${tag}.zip";
    sha256 = hash;
  };

  headersFetcher = vers: hash: fetchurl {
    url = "https://atom.io/download/electron/v${vers}/node-v${vers}-headers.tar.gz";
    sha256 = hash;
  };

  tags = {
    i686-linux = "linux-ia32";
    x86_64-linux = "linux-x64";
    armv7l-linux = "linux-armv7l";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

  get = as: platform: as.${platform.system} or
    "Unsupported system: ${platform.system}";

  common = platform: {
    inherit pname version meta;
    src = fetcher version (get tags platform) (get hashes platform);
    passthru.headers = headersFetcher version hashes.headers;
  };

  electronLibPath = with lib; makeLibraryPath (
    [ libuuid at-spi2-atk at-spi2-core libappindicator-gtk3 ]
    ++ optionals (! versionOlder version "9.0.0") [ libdrm mesa ]
    ++ optionals (! versionOlder version "11.0.0") [ libxkbcommon ]
    ++ optionals (! versionOlder version "12.0.0") [ libxshmfence ]
    ++ optionals (! versionOlder version "17.0.0") [ libglvnd ]
  );

  linux = {
    buildInputs = [ glib gtk3 ];

    nativeBuildInputs = [
      unzip
      makeWrapper
      wrapGAppsHook
    ];

    dontWrapGApps = true; # electron is in lib, we need to wrap it manually

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/lib/electron $out/bin
      unzip -d $out/lib/electron $src
      ln -s $out/lib/electron/electron $out/bin
    '';

    postFixup = ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${electronLibPath}:$out/lib/electron" \
        $out/lib/electron/electron

      wrapProgram $out/lib/electron/electron \
        --prefix LD_PRELOAD : ${lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1 \
        "''${gappsWrapperArgs[@]}"
    '';
  };

  darwin = {
    nativeBuildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      ln -s $out/Applications/Electron.app/Contents/MacOS/Electron $out/bin/electron
    '';
  };
in
  stdenv.mkDerivation (
    (common stdenv.hostPlatform) //
    (if stdenv.isDarwin then darwin else linux)
  )
