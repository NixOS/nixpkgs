{ lib
, stdenv
, fetchurl
, glib
, xorg
, nspr
, nss
, autoPatchelfHook
, unzip
}:

version: hashes:
let
  pname = "electron-chromedriver";

  meta = with lib; {
    homepage = "https://www.electronjs.org/";
    description = "WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard. This is
      an unofficial build of ChromeDriver compiled by the Electronjs
      project.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ liammurphy14 yayayayaka ];
    platforms = ["x86_64-darwin" "x86_64-linux" "armv7l-linux" "aarch64-linux" "aarch64-darwin"];
    mainProgram = "chromedriver";
  };

  fetcher = vers: tag: hash: fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${vers}/chromedriver-v${vers}-${tag}.zip";
    sha256 = hash;
  };

  tags = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    armv7l-linux = "linux-armv7l";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

  get = as: platform: as.${platform.system} or (throw "Unsupported system: ${platform.system}");

  common = platform: {
    inherit pname version meta;
    src = fetcher version (get tags platform) (get hashes platform);

    buildInputs = [
      stdenv.cc.cc.lib
      glib
      xorg.libxcb
      nspr
      nss
    ];
  };

  linux = {
    nativeBuildInputs = [ autoPatchelfHook unzip ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      unzip $src
      install -m777 -D chromedriver $out/bin/chromedriver
      runHook postInstall
    '';
  };

  darwin = {
    nativeBuildInputs = [ unzip ];

    dontUnpack = true;
    dontBuild = true;

    # darwin distributions come with libffmpeg dependecy + icudtl.dat file
    installPhase = ''
      runHook preInstall
      unzip $src
      install -m777 -D chromedriver $out/bin/chromedriver
      cp libffmpeg.dylib $out/bin/libffmpeg.dylib
      cp icudtl.dat $out/bin/icudtl.dat
      runHook postInstall
    '';
  };
in
  stdenv.mkDerivation (
    (common stdenv.hostPlatform) //
    (if stdenv.hostPlatform.isDarwin then darwin else linux)
  )
