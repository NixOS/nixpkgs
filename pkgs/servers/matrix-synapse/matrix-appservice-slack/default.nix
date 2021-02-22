{ pkgs, nodejs, stdenv, fetchFromGitHub, lib, ... }:

let
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = "1.4.0";
    sha256 = "1xm75rgg7yrz40y2w1njiwfwz17a8wwlvr7a6zyxvkl8cqrgzp6d";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.package.override {
  inherit src;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-slack" \
    --add-flags "$out/lib/node_modules/matrix-appservice-slack/lib/app.js"
  '';

  meta = with lib; {
    description = "A Matrix <--> Slack bridge";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
