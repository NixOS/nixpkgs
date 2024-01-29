{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    inherit (self) callPackage;
  in {
  buildManPages = callPackage ./build-skaware-man-pages.nix { };
  buildPackage = callPackage ./build-skaware-package.nix { };
  cleanPackaging = callPackage ./clean-packaging.nix { };

  # execline
  execline = callPackage ./execline { };
  execline-man-pages = callPackage ./execline-man-pages { };

  # servers & tools
  mdevd = callPackage ./mdevd { };
  nsss = callPackage ./nsss { };
  tipidee = callPackage ./tipidee { };
  utmps = callPackage ./utmps { };

  # libs
  skalibs = callPackage ./skalibs { };
  skalibs_2_10 = callPackage ./skalibs/2_10.nix { };
  sdnotify-wrapper = callPackage ./sdnotify-wrapper { };

  # s6 tooling
  s6 = callPackage ./s6 { };
  s6-dns = callPackage ./s6-dns { };
  s6-linux-init = callPackage ./s6-linux-init { };
  s6-linux-utils = callPackage ./s6-linux-utils { };
  s6-networking = callPackage ./s6-networking { };
  s6-portable-utils = callPackage ./s6-portable-utils { };
  s6-rc = callPackage ./s6-rc { };

  s6-man-pages = callPackage ./s6-man-pages { };
  s6-networking-man-pages = callPackage ./s6-networking-man-pages { };
  s6-portable-utils-man-pages = callPackage ./s6-portable-utils-man-pages { };
  s6-rc-man-pages = callPackage ./s6-rc-man-pages { };
})
