{ stdenv, callPackage, CoreFoundation
, tiles ? true, Cocoa
, debug ? false
}:

let
  inherit (stdenv.lib) optionals optionalString;
  inherit (callPackage ./common.nix { inherit tiles Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven installXDGAppLauncher installMacOSAppLauncher;
in

stdenv.mkDerivation (common // rec {
  version = "0.D";
  name = "cataclysm-dda-${version}";

  src = fetchFromCleverRaven {
    rev = "${version}";
    sha256 = "00zzhx1mh1qjq668cga5nbrxp2qk6b82j5ak65skhgnlr6ii4ysc";
  };

  buildInputs = common.buildInputs
    ++ optionals stdenv.isDarwin [ CoreFoundation ];

  patches = [ ./patches/fix_locale_dir.patch ];

  postPatch = common.postPatch + ''
    substituteInPlace lua/autoexec.lua --replace "/usr/share" "$out/share"
  '';

  postInstall = optionalString tiles
  ( if !stdenv.isDarwin
    then installXDGAppLauncher
    else installMacOSAppLauncher
  );

  # Disable, possible problems with hydra
  #enableParallelBuilding = true;

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ skeidel ];
  };
})
