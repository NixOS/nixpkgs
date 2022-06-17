{ pkgs, nodejs, stdenv, lib, ... }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.eask.override {
  name = "eask";
  meta = with lib; {
    description = "Command-line tool for building and testing Emacs Lisp packages";
    homepage = "https://emacs-eask.github.io/";
    maintainers = with maintainers; [ jcs090218 ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
