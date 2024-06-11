{ stdenv, lib, callPackage, CoreFoundation, fetchFromGitHub, fetchpatch, pkgs, wrapCDDA, attachPkgs
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
      ./locale-path.patch
      # Fixes for failing build with GCC 13, remove on updating next release after 0.G
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-dangling-reference-warning.patch";
        hash = "sha256-9nPbyz49IYBOVHqr7jzCIyS8z/SQgpK4EjEz1fruIPE=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-cstdint.patch";
        hash = "sha256-8IBW2OzAHVgEJZoViQ490n37sl31hA55ePuqDL/lil0=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/c/cataclysm-dda/0.G-4/debian/patches/gcc13-keyword-requires.patch";
        hash = "sha256-8yvHh0YKC7AC/qzia7AZAfMewMC0RiSepMXpOkMXRd8=";
      })
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
