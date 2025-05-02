{ stdenv, lib, stdenvNoCC
, fetchzip
, sourceData, versionData, buildFreebsd, patchesRoot
}:

self:

lib.packagesFromDirectoryRecursive {
  callPackage = self.callPackage;
  directory = ./pkgs;
} // {
  inherit sourceData patchesRoot versionData;

  # Keep the crawled portion of Nixpkgs finite.
  buildFreebsd = lib.dontRecurseIntoAttrs buildFreebsd;

  ports = fetchzip {
    url = "https://cgit.freebsd.org/ports/snapshot/ports-dde3b2b456c3a4bdd217d0bf3684231cc3724a0a.tar.gz";
    sha256 = "BpHqJfnGOeTE7tkFJBx0Wk8ryalmf4KNTit/Coh026E=";
  };

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isFreeBSD) self.compat;
  freebsd-lib = import ./lib {
    version = lib.concatStringsSep "." (map toString (lib.filter (x: x != null) [
      self.versionData.major
      self.versionData.minor
      self.versionData.patch or null
    ]));
  };

  # The manual callPackages below should in principle be unnecessary, but are
  # necessary. See note in ../netbsd/default.nix

  compat = self.callPackage ./pkgs/compat/package.nix {
    inherit stdenv;
    inherit (buildFreebsd) makeMinimal boot-install;
  };

  csu = self.callPackage ./pkgs/csu.nix {
    inherit (buildFreebsd) makeMinimal install gencat;
    inherit (self) include;
  };

  include = self.callPackage ./pkgs/include/package.nix {
    inherit (buildFreebsd) makeMinimal install rpcgen;
  };

  install = self.callPackage ./pkgs/install.nix {
    inherit (buildFreebsd) makeMinimal;
    inherit (self) mtree libnetbsd;
  };

  libc = self.callPackage ./pkgs/libc/package.nix {
    inherit (buildFreebsd) makeMinimal install gencat rpcgen;
    inherit (self) csu include;
  };

  libnetbsd = self.callPackage ./pkgs/libnetbsd/package.nix {
    inherit (buildFreebsd) makeMinimal;
  };

  mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
    inherit stdenv;
    inherit (buildFreebsd) makeMinimal install tsort;
  };

  makeMinimal = self.callPackage ./pkgs/makeMinimal.nix {
    inherit (self) make;
  };

}
