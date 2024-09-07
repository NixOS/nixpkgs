{
  lib,
  stdenvNoLibc,
  stdenvNoCC,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  buildPackages,
  fetchcvs,
}:

let
  otherSplices = generateSplicesForMkScope "netbsd";
  buildNetbsd = otherSplices.selfBuildHost;
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
      version = "9.2";

      defaultMakeFlags = [
        "MKSOFTFLOAT=${
          if
            stdenvNoCC.hostPlatform.gcc.float or (stdenvNoCC.hostPlatform.parsed.abi.float or "hard") == "soft"
          then
            "yes"
          else
            "no"
        }"
      ];

      compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isNetBSD) self.compat;

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

      # The manual callPackages below should in principle be unnecessary because
      # they're just selecting arguments that would be selected anyway. However,
      # if we don't perform these manual calls, we get infinite recursion issues
      # because of the splices.

      compat = self.callPackage ./pkgs/compat/package.nix {
        inherit (buildPackages) coreutils;
        inherit (buildNetbsd) makeMinimal;
        inherit (self) install;
      };

      config = self.callPackage ./pkgs/config.nix {
        inherit (buildNetbsd) makeMinimal install;
        inherit (self) cksum;
      };

      csu = self.callPackage ./pkgs/csu.nix {
        inherit (self) headers sys-headers ld_elf_so;
        inherit (buildNetbsd)
          netbsdSetupHook
          makeMinimal
          install
          genassym
          gencat
          lorder
          tsort
          statHook
          ;
      };

      include = self.callPackage ./pkgs/include.nix {
        inherit (buildNetbsd)
          makeMinimal
          install
          nbperf
          rpcgen
          ;
        inherit (buildPackages) stdenv;
      };

      install = self.callPackage ./pkgs/install/package.nix {
        inherit (self)
          fts
          mtree
          make
          compatIfNeeded
          ;
        inherit (buildNetbsd) makeMinimal;
      };

      libcMinimal = self.callPackage ./pkgs/libcMinimal/package.nix {
        inherit (self) headers csu;
        inherit (buildNetbsd)
          netbsdSetupHook
          makeMinimal
          install
          genassym
          gencat
          lorder
          tsort
          statHook
          rpcgen
          ;
      };

      libpthread-headers = self.callPackage ./pkgs/libpthread/headers.nix { };

      librpcsvc = self.callPackage ./pkgs/librpcsvc.nix {
        inherit (buildNetbsd)
          netbsdSetupHook
          makeMinimal
          install
          lorder
          tsort
          statHook
          rpcgen
          ;
      };

      libutil = self.callPackage ./pkgs/libutil.nix {
        inherit (buildNetbsd)
          netbsdSetupHook
          makeMinimal
          install
          lorder
          tsort
          statHook
          ;
      };

      lorder = self.callPackage ./pkgs/lorder.nix { inherit (buildNetbsd) makeMinimal install; };

      mtree = self.callPackage ./pkgs/mtree.nix { inherit (self) mknod; };

      mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
        inherit (buildNetbsd)
          netbsdSetupHook
          makeMinimal
          install
          tsort
          lorder
          ;
        inherit (buildPackages) mandoc;
        inherit (buildPackages.buildPackages) rsync;
      };

      makeMinimal = self.callPackage ./pkgs/makeMinimal.nix { inherit (self) make; };

      # See note in pkgs/stat/package.nix
      stat = self.callPackage ./pkgs/stat/package.nix { inherit (buildNetbsd) makeMinimal install; };

      # See note in pkgs/stat/hook.nix
      statHook = self.callPackage ./pkgs/stat/hook.nix { inherit (self) stat; };

      sys-headers = self.callPackage ./pkgs/sys/headers.nix {
        inherit (buildNetbsd)
          makeMinimal
          install
          tsort
          lorder
          statHook
          uudecode
          config
          genassym
          ;
      };

      tsort = self.callPackage ./pkgs/tsort.nix { inherit (buildNetbsd) makeMinimal install; };
    }
  );
}
