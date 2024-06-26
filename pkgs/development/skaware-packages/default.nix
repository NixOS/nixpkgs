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

  # manpages (DEPRECATED, they are added directly to the packages now)
  execline-man-pages = self.execline.passthru.manpages;
  s6-man-pages = self.s6.passthru.manpages;
  s6-networking-man-pages = self.s6-networking.passthru.manpages;
  s6-portable-utils-man-pages = self.s6-portable-utils.passthru.manpages;
  s6-rc-man-pages = self.s6-rc.passthru.manpages;
})
