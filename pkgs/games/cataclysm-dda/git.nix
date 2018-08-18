{ stdenv, callPackage
, tiles ? true, Cocoa, CoreFoundation
, debug ? false
}:

let
  inherit (stdenv.lib) optionals optionalString substring;
  inherit (callPackage ./common.nix { inherit tiles Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven installXDGAppLauncher installMacOSAppLauncher;
in

stdenv.mkDerivation (common // rec {
  version = "2018-07-15";
  name = "cataclysm-dda-git-${version}";

  src = fetchFromCleverRaven {
    rev = "e1e5d81";
    sha256 = "198wfj8l1p8xlwicj92cq237pzv2ha9pcf240y7ijhjpmlc9jkr1";
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
