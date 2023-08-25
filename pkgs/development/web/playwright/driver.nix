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
    version = "1.34.3";

    src = fetchurl {
      url = "https://playwright.azureedge.net/builds/driver/${filename}";
      sha256 = {
        x86_64-linux = "1xh05v3yqa8gkwayhl4nffgjcnlakpyyi17hwzh0wqzrbwwn0cs8";
        aarch64-linux = "18jxbmhiqda5pzrv6b3n7xi14xg4zvlh6sn7hc3b3hckl77vl933";
        x86_64-darwin = "0fy5nxbvp1kxplavj832gxiznjqpvl0ww869hsfj0h1fibhly7cy";
        aarch64-darwin = "11msl4pnmr8cmlw32xq2qvfz3g3fy0azvq134a47c0fnpj2gd5zl";
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
