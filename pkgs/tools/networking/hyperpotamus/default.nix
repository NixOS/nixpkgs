{ pkgs, nodejs, stdenv, lib, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.hyperpotamus.override {
  meta = with lib; {
    description = "YAML/JSON automation scripting";
    maintainers = with maintainers; [ onny ];
    license = licenses.mit;
    homepage = "https://github.com/pmarkert/hyperpotamus";
  };
}
