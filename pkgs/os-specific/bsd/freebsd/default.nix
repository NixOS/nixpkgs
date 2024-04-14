{ stdenv, lib, stdenvNoCC
, makeScopeWithSplicing', generateSplicesForMkScope
, buildPackages
, fetchgit, fetchzip
}:

let
  inherit (buildPackages.buildPackages) rsync;

  versions = builtins.fromJSON (builtins.readFile ./versions.json);

  version = "13.1.0";
  branch = "release/${version}";

in makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "freebsd";
  f = (self: lib.packagesFromDirectoryRecursive {
    callPackage = self.callPackage;
    directory = ./pkgs;
  } // {
    sourceData = versions.${branch};

    ports = fetchzip {
      url = "https://cgit.freebsd.org/ports/snapshot/ports-dde3b2b456c3a4bdd217d0bf3684231cc3724a0a.tar.gz";
      sha256 = "BpHqJfnGOeTE7tkFJBx0Wk8ryalmf4KNTit/Coh026E=";
    };

    # Why do we have splicing and yet do `nativeBuildInputs = with self; ...`?
    # See note in ../netbsd/default.nix.

    compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isFreeBSD) self.compat;

    freebsd-lib = import ./lib { inherit version; };

    # Overridden arguments avoid cross package-set splicing issues,
    # otherwise would just use implicit
    # `lib.packagesFromDirectoryRecursive` auto-call.

    compat = self.callPackage ./pkgs/compat/package.nix {
      inherit stdenv;
      inherit (buildPackages.freebsd) makeMinimal boot-install;
    };

    csu = self.callPackage ./pkgs/csu.nix {
      inherit (buildPackages.freebsd) makeMinimal install gencat;
      inherit (self) include;
    };

    include = self.callPackage ./pkgs/include/package.nix {
      inherit (buildPackages.freebsd) makeMinimal install rpcgen;
    };

    install = self.callPackage ./pkgs/install.nix {
      inherit (buildPackages.freebsd) makeMinimal;
      inherit (self) mtree libnetbsd;
    };

    libc = self.callPackage ./pkgs/libc/package.nix {
      inherit (buildPackages.freebsd) makeMinimal install gencat rpcgen;
      inherit (self) csu include;
    };

    libnetbsd = self.callPackage ./pkgs/libnetbsd/package.nix {
      inherit (buildPackages.freebsd) makeMinimal;
    };

    mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
      inherit stdenv;
      inherit (buildPackages.freebsd) makeMinimal install tsort;
    };

    makeMinimal = self.callPackage ./pkgs/makeMinimal.nix {
      inherit (self) make;
    };

  });
}
