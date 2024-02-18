{ stdenv, lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2023-08-09-1243"
, rev ? "cdda-experimental-2023-08-09-1243"
, sha256 ? "sha256-pdnvtVE6qkigut2CFuSrPrtiP02EvkOWWnRgfKjn9fo="
}:

let
  common = callPackage ./common.nix {
    inherit CoreFoundation tiles Cocoa debug useXdgDir;
  };

  self = common.overrideAttrs (common: rec {
    pname = common.pname + "-git";
    inherit version;

    src = fetchFromGitHub {
      owner = "CleverRaven";
      repo = "Cataclysm-DDA";
      inherit rev sha256;
    };

    patches = [
      # Unconditionally look for translation files in $out/share/locale
      ./locale-path-git.patch
      ./macosx-ghc-fix-git.patch
    ];

    makeFlags = common.makeFlags ++ [
      "VERSION=${version}"
    ];
  });
in

attachPkgs pkgs self
