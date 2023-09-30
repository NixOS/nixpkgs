{ lib
, stdenv
, chromium
, ffmpeg
, git
, jq
, nodejs
, fetchFromGitHub
, fetchurl
, makeFontsConf
, makeWrapper
, runCommand
, unzip
}:
let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  driver = stdenv.mkDerivation (finalAttrs:
    let
      suffix = {
        x86_64-linux = "linux";
        aarch64-linux = "linux-arm64";
        x86_64-darwin = "mac";
        aarch64-darwin = "mac-arm64";
      }.${system} or throwSystem;
      filename = "playwright-${finalAttrs.version}-${suffix}.zip";
    in
    {
    pname = "playwright-driver";
    # run ./pkgs/development/python-modules/playwright/update.sh to update
    version = "1.38.0";

    src = fetchurl {
      url = "https://playwright.azureedge.net/builds/driver/${filename}";
      sha256 = {
        x86_64-linux = "1zs8mfn41k5kv1r6vw8x3hw7z7ghmwfrvdhx9lvcllhrdiqzqkbm";
        aarch64-linux = "0m2mnvhfqyqjwmb0jdmwdsw0xacr85g5wy0dipl0i8ylb9zjzq7z";
        x86_64-darwin = "0jik9d80ina2439nmnd4frmmcjimyqr888gwrm6i136hla27i3a9";
        aarch64-darwin = "1ma2f51hz5xjp55yn9x1s4qg62df12lrr4dy4kdqc6wiqdxc96f3";
      }.${system} or throwSystem;
    };

    sourceRoot = ".";

    nativeBuildInputs = [ unzip ];

    postPatch = ''
      # Use Nix's NodeJS instead of the bundled one.
      substituteInPlace playwright.sh --replace '"$SCRIPT_PATH/node"' '"${nodejs}/bin/node"'
      rm node

      # Hard-code the script path to $out directory to avoid a dependency on coreutils
      substituteInPlace playwright.sh \
        --replace 'SCRIPT_PATH="$(cd "$(dirname "$0")" ; pwd -P)"' "SCRIPT_PATH=$out"

      patchShebangs playwright.sh package/bin/*.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mv playwright.sh $out/bin/playwright
      mv package $out/

      runHook postInstall
    '';

    passthru = {
      inherit filename;
      browsers = {
        x86_64-linux = browsers-linux { };
        aarch64-linux = browsers-linux { };
        x86_64-darwin = browsers-mac;
        aarch64-darwin = browsers-mac;
      }.${system} or throwSystem;
      browsers-chromium = browsers-linux {};
    };
  });

  browsers-mac = stdenv.mkDerivation {
    pname = "playwright-browsers";
    inherit (driver) version;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${driver}/bin/playwright install
      rm -r $out/.links

      runHook postInstall
    '';

    meta.platforms = lib.platforms.darwin;
  };

  browsers-linux = { withChromium ? true }: let
    fontconfig = makeFontsConf {
      fontDirectories = [];
    };
  in
    runCommand ("playwright-browsers"
    + lib.optionalString withChromium "-chromium")
  {
    nativeBuildInputs = [
      makeWrapper
      jq
    ];
  } (''
    BROWSERS_JSON=${driver}/package/browsers.json
  '' + lib.optionalString withChromium ''
    CHROMIUM_REVISION=$(jq -r '.browsers[] | select(.name == "chromium").revision' $BROWSERS_JSON)
    mkdir -p $out/chromium-$CHROMIUM_REVISION/chrome-linux

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    makeWrapper ${chromium}/bin/chromium $out/chromium-$CHROMIUM_REVISION/chrome-linux/chrome \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set FONTCONFIG_FILE ${fontconfig}
  '' + ''
    FFMPEG_REVISION=$(jq -r '.browsers[] | select(.name == "ffmpeg").revision' $BROWSERS_JSON)
    mkdir -p $out/ffmpeg-$FFMPEG_REVISION
    ln -s ${ffmpeg}/bin/ffmpeg $out/ffmpeg-$FFMPEG_REVISION/ffmpeg-linux
  '');
in
  driver
