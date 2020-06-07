{ pkgs, stdenv, lib, ... }:

let
  phpPackages = import ./composer-composition.nix {
    inherit (stdenv.hostPlatform) system;
  };
in
phpPackages.override {
  # nativeBuildInputs = [ pkgs.makeWrapper ];

  meta = with lib; {
    description = "The server control and management daemon built specifically for Pterodactyl Panel";
    maintainers = with maintainers; [ jakestanger ];
    license = licenses.mit;
  };
}