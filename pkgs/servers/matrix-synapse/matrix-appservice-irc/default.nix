{ pkgs, nodePackages, makeWrapper, nixosTests, nodejs, stdenv, lib, fetchFromGitHub, fetchurl, autoPatchelfHook }:

let
  ourNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  version = (lib.importJSON ./package.json).version;
  srcInfo = lib.importJSON ./src.json;

  # TODO: package matrix-rust-sdk and use that instead of fetching & patching binaries
  platform = {
    "x86_64-linux" = "linux-x64-gnu";
    "aarch64-linux" = "linux-arm64-gnu";
  }.${stdenv.hostPlatform.system} or
    (throw "matrix-appservice-irc: Unsupported platform ${stdenv.hostPlatform.system}");

  matrix-sdk-crypto = let
    version = "0.1.0-beta.1";
    base = "https://github.com/matrix-org/matrix-rust-sdk/releases/download/matrix-sdk-crypto-nodejs-v${version}";
  in
    fetchurl {
      url = "${base}/matrix-sdk-crypto.${platform}.node";
      hash = {
        "x86_64-linux" = "sha256-a6FX+KhHooipIMsJ7Fl7gmUBt8WbTUgT6sXN4N3NXRk=";
        "aarch64-linux" = "sha256-jvr6gMTQ4aAk5x0iXpA28ADdaCgDpvOjmogd52Z6bIY=";
      }.${stdenv.hostPlatform.system} or
        (throw "matrix-appservice-irc: Unsupported platform ${stdenv.hostPlatform.system}");
    };
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

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
      --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"

    # install the native bindings for matrix-sdk-crypto
    export CRYPTO_SDK_PATH="$out/lib/node_modules/matrix-appservice-irc/node_modules/@matrix-org/matrix-sdk-crypto-nodejs/matrix-sdk-crypto.${platform}.node"
    cp -v ${matrix-sdk-crypto} "$CRYPTO_SDK_PATH"
    autoPatchelf "$CRYPTO_SDK_PATH"
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
