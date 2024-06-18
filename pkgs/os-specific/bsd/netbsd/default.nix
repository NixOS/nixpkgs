{
  lib,
  crossLibcStdenv,
  stdenvNoCC,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  buildPackages,
  fetchcvs,
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "netbsd";
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

      stdenvLibcMinimal = crossLibcStdenv.override (old: {
        cc = old.cc.override {
          libc = self.libcMinimal;
          bintools = old.cc.bintools.override {
            libc = self.libcMinimal;
            sharedLibraryLoader = null;
          };
        };
      });

      # The manual callPackages below should in principle be unnecessary because
      # they're just selecting arguments that would be selected anyway. However,
      # if we don't perform these manual calls, we get infinite recursion issues
      # because of the splices.

      mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
        inherit (buildPackages.netbsd)
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

      compat = self.callPackage ./pkgs/compat/package.nix {
        inherit (buildPackages) coreutils;
        inherit (buildPackages.darwin) cctools-port;
        inherit (buildPackages.netbsd) makeMinimal;
        inherit (self) install;
      };

      install = self.callPackage ./pkgs/install/package.nix {
        inherit (self)
          fts
          mtree
          make
          compatIfNeeded
          ;
        inherit (buildPackages.netbsd) makeMinimal;
      };

      # See note in pkgs/stat/package.nix
      stat = self.callPackage ./pkgs/stat/package.nix {
        inherit (buildPackages.netbsd) makeMinimal install;
      };

      # See note in pkgs/stat/hook.nix
      statHook = self.callPackage ./pkgs/stat/hook.nix { inherit (self) stat; };

      tsort = self.callPackage ./pkgs/tsort.nix { inherit (buildPackages.netbsd) makeMinimal install; };

      lorder = self.callPackage ./pkgs/lorder.nix { inherit (buildPackages.netbsd) makeMinimal install; };

      config = self.callPackage ./pkgs/config.nix {
        inherit (buildPackages.netbsd) makeMinimal install;
        inherit (self) cksum;
      };

      include = self.callPackage ./pkgs/include.nix {
        inherit (buildPackages.netbsd)
          makeMinimal
          install
          nbperf
          rpcgen
          ;
        inherit (buildPackages) stdenv;
      };

      sys-headers = self.callPackage ./pkgs/sys/headers.nix {
        inherit (buildPackages.netbsd)
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

      libutil = self.callPackage ./pkgs/libutil.nix {
        inherit (buildPackages.netbsd)
          netbsdSetupHook
          makeMinimal
          install
          lorder
          tsort
          statHook
          ;
      };

      libpthread-headers = self.callPackage ./pkgs/libpthread/headers.nix { };

      csu = self.callPackage ./pkgs/csu.nix {
        inherit (self) headers sys-headers ld_elf_so;
        inherit (buildPackages.netbsd)
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

      libcMinimal = self.callPackage ./pkgs/libcMinimal.nix {
        inherit (self) headers csu;
        inherit (buildPackages.netbsd)
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

      librpcsvc = self.callPackage ./pkgs/librpcsvc.nix {
        inherit (buildPackages.netbsd)
          netbsdSetupHook
          makeMinimal
          install
          lorder
          tsort
          statHook
          rpcgen
          ;
      };

      mtree = self.callPackage ./pkgs/mtree.nix { inherit (self) mknod; };
    }
  );
}
