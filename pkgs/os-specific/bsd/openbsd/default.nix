{
  lib,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  buildPackages,
}:

let
  otherSplices = generateSplicesForMkScope "openbsd";
  buildOpenbsd = otherSplices.selfBuildHost;
in

makeScopeWithSplicing' {
  inherit otherSplices;
  f = (
    self:
    lib.packagesFromDirectoryRecursive {
      callPackage = self.callPackage;
      directory = ./pkgs;
    }
    // {
      libc = self.callPackage ./pkgs/libc/package.nix {
        inherit (self) csu include;
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd)
          install
          gencat
          rpcgen
          tsort
          ;
      };
      makeMinimal = buildPackages.netbsd.makeMinimal.override { inherit (self) make-rules; };
      mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
        inherit (buildPackages.netbsd) install;
        inherit (buildPackages.buildPackages) rsync;
      };
      include = self.callPackage ./pkgs/include/package.nix {
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd) install rpcgen mtree;
      };
      csu = self.callPackage ./pkgs/csu.nix {
        inherit (self) include;
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd) install;
      };
      make-rules = self.callPackage ./pkgs/make-rules/package.nix { };
      lorder = self.callPackage ./pkgs/lorder.nix { inherit (buildPackages.netbsd) install; };
    }
  );
}
