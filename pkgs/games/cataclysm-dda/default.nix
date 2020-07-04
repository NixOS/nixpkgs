{ stdenv, callPackage, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (callPackage ./common.nix { inherit tiles CoreFoundation Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven;
in

stdenv.mkDerivation (common // rec {
  version = "0.E";
  name = "cataclysm-dda-${version}";

  src = fetchFromCleverRaven {
    rev = version;
    sha256 = "0pbi0fw37zimzdklfj58s1ql0wlqq7dy6idkcsib3hn910ajaxan";
  };

  patches = [ ./patches/fix_locale_dir.patch ];

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ skeidel ];
  };
})
