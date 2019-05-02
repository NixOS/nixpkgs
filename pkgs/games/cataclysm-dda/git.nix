{ stdenv, callPackage, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (stdenv.lib) optionals optionalString substring;
  inherit (callPackage ./common.nix { inherit tiles Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven installXDGAppLauncher installMacOSAppLauncher;
in

stdenv.mkDerivation (common // rec {
  version = "2019-05-03";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromCleverRaven {
    rev = "65a05026e7306b5d1228dc6ed885c43447f128b5";
    sha256 = "18yn0h6b4j9lx67sq1d886la3l6l7bqsnwj6mw2khidssiy18y0n";
  };

  buildInputs = common.buildInputs
    ++ optionals stdenv.isDarwin [ CoreFoundation ];

  patches = [ ./patches/fix_locale_dir_git.patch ];

  makeFlags = common.makeFlags ++ [
    "VERSION=git-${version}-${substring 0 8 src.rev}"
  ];

  postInstall = optionalString tiles
  ( if !stdenv.isDarwin
    then installXDGAppLauncher
    else installMacOSAppLauncher
  );

  # https://hydra.nixos.org/build/65193254
  # src/weather_data.cpp:203:1: fatal error: opening dependency file obj/tiles/weather_data.d: No such file or directory
  # make: *** [Makefile:687: obj/tiles/weather_data.o] Error 1
  enableParallelBuilding = false;

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ rardiol ];
  };
})
