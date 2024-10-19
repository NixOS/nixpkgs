{ lib, callPackage, CoreFoundation, fetchFromGitHub, fetchpatch, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2024-07-28"
, rev ? "bfeb1fffc4179fed242a042f24b1c97f6cfaff3d"
, sha256 ? "sha256-IodXEA+pWfDdR9huRXieP3+J3WZJO19C8PUPT18dFBw="
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
