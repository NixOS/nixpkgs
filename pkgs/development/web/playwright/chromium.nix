{ runCommand
, makeWrapper
, makeFontsConf
, jq
, chromium
, ...
}:
let
  fontconfig = makeFontsConf {
    fontDirectories = [];
  };
in
runCommand "playwright-browsers"
{
  nativeBuildInputs = [
    makeWrapper
    jq
  ];
} ''
  mkdir -p $out/chrome-linux

  # See here for the Chrome options:
  # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
  makeWrapper ${chromium}/bin/chromium $out/chrome-linux/chrome \
    --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
    --set FONTCONFIG_FILE ${fontconfig}
  ''
