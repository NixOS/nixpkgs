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
  version = "2019-05-03";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromCleverRaven {
    rev = "65a05026e7306b5d1228dc6ed885c43447f128b5";
    sha256 = "18yn0h6b4j9lx67sq1d886la3l6l7bqsnwj6mw2khidssiy18y0n";
  };

  patches = [ ./patches/fix_locale_dir_git.patch ];

  makeFlags = common.makeFlags ++ [
    "VERSION=git-${version}-${substring 0 8 src.rev}"
  ];

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ rardiol ];
  };
})
