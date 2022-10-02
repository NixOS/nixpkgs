{ pkgs, nodejs, stdenv, fetchFromGitHub, lib, ... }:
let
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "matrix-appservice-slack";
    rev = "1.11.0";
    sha256 = "U1EHL1ZwcpCXA9sjya6ry/3Q+gwdQWPUDFN+wp1qjrg=";
  };

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.package.override {
  pname = "matrix-appservice-slack";

  inherit src;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/matrix-appservice-slack" \
    --add-flags "$out/lib/node_modules/matrix-appservice-slack/lib/app.js"
  '';

  meta = with lib; {
    description = "A Matrix <--> Slack bridge";
    maintainers = with maintainers; [ beardhatcode ];
    license = licenses.asl20;
  };
}
