{ stdenv, lib, stdenvNoCC
, makeScopeWithSplicing', generateSplicesForMkScope
, buildPackages
, bsdSetupHook, makeSetupHook, fetchcvs, groff, mandoc, byacc, flex
, zlib
, writeShellScript, writeText, runtimeShell, symlinkJoin
}:

let
  fetchNetBSD = path: version: sha256: fetchcvs {
    cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
    module = "src/${path}";
    inherit sha256;
    tag = "netbsd-${lib.replaceStrings ["."] ["-"] version}-RELEASE";
  };

  netbsdSetupHook = makeSetupHook {
    name = "netbsd-setup-hook";
  } ./setup-hook.sh;

  defaultMakeFlags = [
    "MKSOFTFLOAT=${if stdenv.hostPlatform.gcc.float or (stdenv.hostPlatform.parsed.abi.float or "hard") == "soft"
      then "yes"
      else "no"}"
  ];

in makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "netbsd";
  f = (self: lib.packagesFromDirectoryRecursive {
    callPackage = self.callPackage;
    directory = ./pkgs;
  } // (let inherit (self) mkDerivation; in {

  inherit defaultMakeFlags fetchNetBSD netbsdSetupHook;

  # Why do we have splicing and yet do `nativeBuildInputs = with self; ...`?
  #
  # We use `makeScopeWithSplicing'` because this should be used for all
  # nested package sets which support cross, so the inner `callPackage` works
  # correctly. But for the inline packages we don't bother to use
  # `callPackage`.
  #
  # We still could have tried to `with` a big spliced packages set, but
  # splicing is jank and causes a number of bootstrapping infinite recursions
  # if one is not careful. Pulling deps out of the right package set directly
  # side-steps splicing entirely and avoids those footguns.
  #
  # For non-bootstrap-critical packages, we might as well use `callPackage` for
  # consistency with everything else, and maybe put in separate files too.

  compatIfNeeded = lib.optional (!stdenvNoCC.hostPlatform.isNetBSD) self.compat;

  mkDerivation = self.callPackage ./pkgs/mkDerivation.nix {
    inherit stdenv stdenvNoCC;
    inherit (buildPackages.netbsd) netbsdSetupHook makeMinimal install tsort lorder;
    inherit (buildPackages) mandoc;
    inherit (buildPackages.buildPackages) rsync;

  };

  makeMinimal = self.callPackage ./pkgs/makeMinimal.nix {
    inherit (self) make;
  };

  compat = self.callPackage ./pkgs/compat/package.nix {
    inherit (buildPackages) coreutils;
    inherit (buildPackages.darwin) cctools-port;
    inherit (buildPackages.buildPackages) rsync;
    inherit (buildPackages.netbsd) makeMinimal;
    inherit (self) install include libc libutil;
  };

  install = self.callPackage ./pkgs/install/package.nix {
    inherit (self) fts mtree make compatIfNeeded;
    inherit (buildPackages.buildPackages) rsync;
    inherit (buildPackages.netbsd) makeMinimal;
  };

  # Don't add this to nativeBuildInputs directly.
  # Use statHook instead.
  stat = self.callPackage ./pkgs/stat/package.nix {
    inherit (buildPackages.netbsd) makeMinimal install;
    inherit (buildPackages.buildPackages) rsync;
  };

  # stat isn't in POSIX, and NetBSD stat supports a completely
  # different range of flags than GNU stat, so including it in PATH
  # breaks stdenv.  Work around that with a hook that will point
  # NetBSD's build system and NetBSD stat without including it in
  # PATH.
  statHook = self.callPackage ./pkgs/stat/hook.nix {
    inherit (self) stat;
  };

  tsort = self.callPackage ./pkgs/tsort.nix {
    inherit (buildPackages.netbsd) makeMinimal install;
    inherit (buildPackages.buildPackages) rsync;
  };

  lorder = self.callPackage ./pkgs/lorder.nix {
    inherit (buildPackages.netbsd) makeMinimal install;
    inherit (buildPackages.buildPackages) rsync;
  };

  config = self.callPackage ./pkgs/config.nix {
    inherit (buildPackages.netbsd) makeMinimal install;
    inherit (buildPackages.buildPackages) rsync;
    inherit (self) cksum;
  };

  include = self.callPackage ./pkgs/include.nix {
    inherit (buildPackages.netbsd)
      makeMinimal install nbperf rpcgen;
    inherit (buildPackages) stdenv;
    inherit (buildPackages.buildPackages) rsync;
  };

  sys-headers = self.callPackage ./pkgs/sys/headers.nix {
    inherit (buildPackages.netbsd)
      makeMinimal install tsort lorder statHook uudecode config genassym;
    inherit (buildPackages.buildPackages) rsync;
  };

  libutil = self.callPackage ./pkgs/libutil.nix {
    inherit (self) libc sys;
  };

  libpthread-headers = self.callPackage ./pkgs/libpthread/headers.nix { };

  csu = self.callPackage ./pkgs/csu.nix {
    inherit (self) headers sys ld_elf_so;
    inherit (buildPackages.netbsd)
      netbsdSetupHook
      makeMinimal
      install
      genassym gencat lorder tsort statHook;
    inherit (buildPackages.buildPackages) rsync;
  };

  _mainLibcExtraPaths = with self; [
      common i18n_module.src sys.src
      ld_elf_so.src libpthread.src libm.src libresolv.src
      librpcsvc.src libutil.src librt.src libcrypt.src
  ];

  libc = self.callPackage ./pkgs/libc.nix {
    inherit (self) headers csu librt;
    inherit (buildPackages.netbsd)
      netbsdSetupHook
      makeMinimal
      install
      genassym gencat lorder tsort statHook rpcgen;
    inherit (buildPackages.buildPackages) rsync;
  };

}));
}
