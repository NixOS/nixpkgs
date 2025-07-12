{
  lib,
  stdenvNoLibc,
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
      version = "7.5";

      stdenvLibcMinimal = stdenvNoLibc.override (old: {
        cc = old.cc.override {
          libc = self.libcMinimal;
          noLibc = false;
          bintools = old.cc.bintools.override {
            libc = self.libcMinimal;
            noLibc = false;
            sharedLibraryLoader = null;
          };
        };
      });

      makeMinimal = buildPackages.netbsd.makeMinimal.override { inherit (self) make-rules; };

      # The manual callPackages below should in principle be unnecessary, but are
      # necessary. See note in ../netbsd/default.nix

      include = self.callPackage ./pkgs/include/package.nix {
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd) install rpcgen mtree;
      };

      csu = self.callPackage ./pkgs/csu.nix {
        inherit (self) include;
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd) install;
      };

      libcMinimal = self.callPackage ./pkgs/libcMinimal/package.nix {
        inherit (self) csu include;
        inherit (buildOpenbsd) makeMinimal;
        inherit (buildPackages.netbsd)
          install
          gencat
          tsort
          rpcgen
          ;
      };

      librpcsvc = self.callPackage ./pkgs/librpcsvc.nix {
        inherit (buildOpenbsd) openbsdSetupHook makeMinimal lorder;
        inherit (buildPackages.netbsd)
          install
          tsort
          statHook
          rpcgen
          ;
      };

      libutil = self.callPackage ./pkgs/libutil.nix {
        inherit (self) libcMinimal;
        inherit (buildOpenbsd) openbsdSetupHook makeMinimal lorder;
        inherit (buildPackages.netbsd) install tsort statHook;
      };

      lorder = self.callPackage ./pkgs/lorder.nix { inherit (buildPackages.netbsd) install; };

      make-rules = self.callPackage ./pkgs/make-rules/package.nix { };

      mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
        inherit (buildPackages.netbsd) install tsort;
        inherit (buildPackages.buildPackages) rsync;
      };
    }
  );
}
