{ stdenv, callPackage, ncurses
, tiles ? true, Cocoa, libicns
, debug ? false
}:

let
  inherit (stdenv.lib) optionals optionalString;
  inherit (callPackage ./common.nix { inherit tiles Cocoa debug; }) common utils;
  inherit (utils) fetchFromCleverRaven installMacOSAppLauncher;
in

stdenv.mkDerivation (common // rec {
  version = "0.C";
  name = "cataclysm-dda-${version}";

  src = fetchFromCleverRaven {
    rev = "${version}";
    sha256 = "03sdzsk4qdq99qckq0axbsvg1apn6xizscd8pwp5w6kq2fyj5xkv";
  };

  nativeBuildInputs = common.nativeBuildInputs
    ++ optionals (tiles && stdenv.isDarwin) [ libicns ];

  patches = [ ./patches/fix_locale_dir.patch ];

  makeFlags = common.makeFlags
    ++ optionals stdenv.isDarwin [
    "OSX_MIN=10.6"  # SDL for macOS only supports deploying on 10.6 and above
  ] ++ optionals stdenv.cc.isGNU [
    "WARNINGS+=-Wno-deprecated-declarations"
    "WARNINGS+=-Wno-ignored-attributes"
  ] ++ optionals stdenv.cc.isClang [
    "WARNINGS+=-Wno-inconsistent-missing-override"
  ];

  NIX_CFLAGS_COMPILE = optionalString stdenv.cc.isClang "-Wno-user-defined-warnings";

  postBuild = optionalString (tiles && stdenv.isDarwin) ''
    # iconutil on macOS is not available in nixpkgs
    png2icns data/osx/AppIcon.icns data/osx/AppIcon.iconset/*
  '';

  postInstall = optionalString (tiles && stdenv.isDarwin)
    installMacOSAppLauncher;

  # Disable, possible problems with hydra
  #enableParallelBuilding = true;

  meta = with stdenv.lib.maintainers; common.meta // {
    maintainers = common.meta.maintainers ++ [ skeidel ];
  };
})
