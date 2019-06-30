{ stdenv, pkgs, nodejs, fetchFromGitHub, git }:

let
  shortRevision = "c982db4";

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in nodePackages."firefox-send-git+https://github.com/mozilla/send#v3.0.12".override {
  nativeBuildInputs = [ git ];

  dontNpmInstall = true;

  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "1";

  postInstall = ''
    sed "1 s,.*,#!${nodejs}/bin/node," -i $out/lib/node_modules/firefox-send/node_modules/.bin/webpack

    # Needed to autodetect git revision, for the Version plugin of Webpack
    sed '1 s,.*,const commit = "${shortRevision}",' -i build/version_plugin.js

    npm run build
  '';
}
