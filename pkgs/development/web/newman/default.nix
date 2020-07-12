{ pkgs, nodejs, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.newman.override {
  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "Newman is a command-line collection runner for Postman";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
