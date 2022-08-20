{ stdenv, lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2022-08-19"
, rev ? "725e825d6f77d7d8cd70b9be39a5e67d5186969d"
, sha256 ? "sha256-h+swzUuxP7xz0iYTD2mRNgxZp47fVJ1zHiqLWOlc9Z0="
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
    ];

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ rardiol ];
    };
  });
in

attachPkgs pkgs self
