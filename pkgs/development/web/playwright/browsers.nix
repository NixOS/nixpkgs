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
, playwright-driver
}:
let

  # playwright.browsers

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
    BROWSERS_JSON=${playwright-driver}/package/browsers.json
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

  browsers-mac = stdenv.mkDerivation {
    pname = "playwright-browsers";
    inherit (playwright-driver) version;

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${playwright-driver}/bin/playwright install
      rm -r $out/.links

      runHook postInstall
    '';

    meta.platforms = lib.platforms.darwin;
  };

in
{
  inherit browsers-linux;
  inherit browsers-mac;
}
