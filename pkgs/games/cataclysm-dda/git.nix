{ stdenv, lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2022-08-20"
, rev ? "f65b2bc4c6dea24bd9a993b8df146e5698e7e36f"
, sha256 ? "sha256-00Tp9OmsM39PYwAJXKKRS9zmn7KsGQ9s1eVmEqghkpw="
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
