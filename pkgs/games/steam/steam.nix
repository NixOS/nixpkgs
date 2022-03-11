{ callPackage, lib, stdenv }:

let
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
in callPackage package {
  version = "1.0.0.74";
  pname = "steam-original";
  meta = {
    description = "A digital distribution platform";
    homepage = "https://store.steampowered.com/";
    license = lib.licenses.unfreeRedistributable;
  };
}
