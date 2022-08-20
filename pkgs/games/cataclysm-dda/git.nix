{ stdenv, lib, callPackage, CoreFoundation, fetchFromGitHub, pkgs, wrapCDDA, attachPkgs
, tiles ? true, Cocoa
, debug ? false
, useXdgDir ? false
, version ? "2021-07-03"
, rev ? "9017808252e1e149446c8f8bd7a6582ce0f95285"
, sha256 ? "0qrvkbyg098jb9hv69sg5093b1vj8f4n75p73v01jnmyxlz3ax28"
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

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    meta = common.meta // {
      maintainers = with lib.maintainers;
      common.meta.maintainers ++ [ rardiol ];
      # /nix/store/s8xaq3x7mcysvd752in2nihb1nr6svsl-SDL2-2.0.20-dev/include/SDL2/SDL_events.h:645:65: error: use of old-style cast [-Werror,-Wold-style-cast]
      broken = (stdenv.isDarwin && stdenv.isx86_64);
    };
  });
in

attachPkgs pkgs self
