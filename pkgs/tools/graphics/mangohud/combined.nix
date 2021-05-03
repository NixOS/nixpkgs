{ stdenv, pkgs, lib
, libXNVCtrl
}:
let
  mangohud_64 = pkgs.callPackage ./default.nix { inherit libXNVCtrl; };
  mangohud_32 = pkgs.pkgsi686Linux.callPackage ./default.nix { inherit libXNVCtrl; };
in
pkgs.buildEnv rec {
  name = "mangohud-${mangohud_64.version}";

  paths = [ mangohud_32 ] ++ lib.optionals stdenv.is64bit [ mangohud_64 ];

  meta = mangohud_64.meta;
}
