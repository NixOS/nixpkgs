{ stdenv, callPackage, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (stdenv.lib) substring;
  inherit (callPackage ./common.nix { inherit tiles CoreFoundation Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven;
in

stdenv.mkDerivation (common // rec {
  version = "2019-11-22";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromCleverRaven {
    rev = "a6c8ece992bffeae3788425dd4b3b5871e66a9cd";
    sha256 = "0ww2q5gykxm802z1kffmnrfahjlx123j1gfszklpsv0b1fccm1ab";
  };

  patches = [
    # Locale patch required for Darwin builds, see: https://github.com/NixOS/nixpkgs/pull/74064#issuecomment-560083970
    ./patches/fix_locale_dir_git.patch
  ];

  makeFlags = common.makeFlags ++ [
    "VERSION=git-${version}-${substring 0 8 src.rev}"
  ];

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ rardiol ];
  };
})
