{ lib, stdenv, pkgs }:
let
  version = "0.38.2";
in
(import ./hyperpotamus.nix {
  inherit pkgs;
  inherit (stdenv.hostPlatform) system;
})."hyperpotamus-${version}".override {
  meta = {
    description = "YAML/JSON automation scripting";
    homepage = "https://github.com/pmarkert/hyperpotamus";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}

