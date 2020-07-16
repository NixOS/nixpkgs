{ stdenv, callPackage, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (callPackage ./common.nix { inherit tiles CoreFoundation Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven;
in

stdenv.mkDerivation (common // rec {
  version = "0.E-2";
  name = "cataclysm-dda-${version}";

  src = fetchFromCleverRaven {
    rev = version;
    sha256 = "15l6w6lxays7qmsv0ci2ry53asb9an9dh7l7fc13256k085qcg68";
  };

  patches = [ ./patches/fix_locale_dir.patch ];

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ skeidel ];
  };
})
