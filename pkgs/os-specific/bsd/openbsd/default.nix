{
  stdenv,
  lib,
  stdenvNoCC,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  pkgs,
  buildPackages,
  netbsd,
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "openbsd";
  f = (
    self:
    lib.packagesFromDirectoryRecursive {
      callPackage = self.callPackage;
      directory = ./pkgs;
    }
    // {
      libc = self.callPackage ./pkgs/libc/package.nix {
        inherit (self) csu include lorder;
        inherit (buildPackages.openbsd) makeMinimal;
        inherit (buildPackages.netbsd)
          install
          gencat
          rpcgen
          tsort
          ;
      };
      makeMinimal = buildPackages.netbsd.makeMinimal.override { inherit (self) make-rules; };
      mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
        inherit stdenv;
        inherit (buildPackages.netbsd) install;
      };
      include = self.callPackage ./pkgs/include/package.nix {
        inherit (buildPackages.openbsd) makeMinimal;
        inherit (buildPackages.netbsd) install rpcgen mtree;
      };
      csu = self.callPackage ./pkgs/csu.nix {
        inherit (self) include;
        inherit (buildPackages.openbsd) makeMinimal;
        inherit (buildPackages.netbsd) install;
      };
      make-rules = self.callPackage ./pkgs/make-rules/package.nix { };
      lorder = self.callPackage ./pkgs/lorder.nix { inherit (buildPackages.netbsd) install; };
    }
  );
}
