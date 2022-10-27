{ pkgs, nodePackages, makeWrapper, nixosTests, nodejs, stdenv, lib, fetchFromGitHub, fetchurl, autoPatchelfHook, matrix-sdk-crypto-nodejs }:

let
  ourNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  version = (lib.importJSON ./package.json).version;
  srcInfo = lib.importJSON ./src.json;
in
ourNodePackages.package.override {
  pname = "matrix-appservice-irc";
  inherit version;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = version;
    inherit (srcInfo) sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper nodePackages.node-gyp-build ];

  dontAutoPatchelf = true;

  postRebuild = ''
    npm run build
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
      --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"

      cp -rv ${matrix-sdk-crypto-nodejs}/lib/node_modules/@matrix-org/matrix-sdk-crypto-nodejs $out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
