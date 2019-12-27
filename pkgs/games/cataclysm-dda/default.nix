{ stdenv, callPackage, lua, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (callPackage ./common.nix { inherit tiles CoreFoundation Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven;
in

stdenv.mkDerivation (common // rec {
  version = "0.D";
  name = "cataclysm-dda-${version}";

  src = fetchFromCleverRaven {
    rev = version;
    sha256 = "00zzhx1mh1qjq668cga5nbrxp2qk6b82j5ak65skhgnlr6ii4ysc";
  };

  buildInputs = common.buildInputs ++ [ lua ];

  patches = [ ./patches/fix_locale_dir.patch ];

  postPatch = common.postPatch + ''
    substituteInPlace lua/autoexec.lua --replace "/usr/share" "$out/share"
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-error=deprecated-copy";

  makeFlags = common.makeFlags ++ [
    "LUA=1"
  ];

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ skeidel ];
  };
})
