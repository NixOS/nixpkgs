{
  lib,
  pkgs,
  stdenv
}:

let
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
  mkKeybaseGui = pkgs.callPackage package {};
in

mkKeybaseGui {
  pname = "keybase-gui";
  meta = {
    homepage = "https://www.keybase.io/";
    description = "The Keybase official GUI";
    license = lib.licenses.bsd3;
  };
}
