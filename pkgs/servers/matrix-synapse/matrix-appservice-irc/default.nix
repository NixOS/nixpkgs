{ pkgs, nodePackages, makeWrapper, nixosTests, nodejs, stdenv, lib, fetchFromGitHub }:

let
  ourNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  version = builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile ./REVISION);
in
ourNodePackages.package.override {
  pname = "matrix-appservice-irc";
  inherit version;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-irc";
    rev = version;
    sha256 = "sha256-EncodJKptrLC54B5XipkiHXFgJ5cD+crcT3SOPOc+7M=";
  };

  nativeBuildInputs = [ makeWrapper nodePackages.node-gyp-build ];

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-irc" \
      --add-flags "$out/lib/node_modules/matrix-appservice-irc/app.js"
  '';

  passthru.tests.matrix-appservice-irc = nixosTests.matrix-appservice-irc;
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Node.js IRC bridge for Matrix";
    maintainers = with maintainers; [ piegames ];
    homepage = "https://github.com/matrix-org/matrix-appservice-irc";
    license = licenses.asl20;
  };
}
