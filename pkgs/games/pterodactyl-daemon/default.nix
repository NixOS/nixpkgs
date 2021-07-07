{ pkgs, nodejs, stdenv, lib, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.package.override {
  nativeBuildInputs = [ pkgs.makeWrapper ];

  preRebuild = ''
    patch -p1 < ${./config.patch}
  '';

  postInstall = "";

  meta = with lib; {
    description = "The server control and management daemon built specifically for Pterodactyl Panel";
    maintainers = with maintainers; [ jakestanger ];
    license = licenses.mit;
  };
}