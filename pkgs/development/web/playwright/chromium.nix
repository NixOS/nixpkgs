{
  runCommand,
  makeWrapper,
  makeFontsConf,
  chromium,
  ...
}:
let
  fontconfig = makeFontsConf {
    fontDirectories = [ ];
  };
in
runCommand "playwright-chromium"
  {
    nativeBuildInputs = [
      makeWrapper
    ];
  }
  ''
    mkdir -p $out/chrome-linux

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    # We add --disable-gpu to be able to run in gpu-less environments such
    # as headless nixos test vms.
    makeWrapper ${chromium}/bin/chromium $out/chrome-linux/chrome \
      --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set-default FONTCONFIG_FILE ${fontconfig}
  ''
