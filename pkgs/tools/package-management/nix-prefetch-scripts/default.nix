{
  lib,
  stdenvNoCC,
  writeTextFile,
  buildEnv,
  bash,
  dash,
  breezy,
  cacert,
  coreutils,
  cvs,
  darcs,
  findutils,
  gawk,
  git,
  git-lfs,
  gnugrep,
  gnused,
  jq,
  mercurial,
  pijul,
  subversion,
}:

let
  mkPrefetchScript =
    {
      tool,
      src,
      # most of the prefetch scripts are POSIX-compliant, so Bash’s overhead
      # isn’t required
      shell ? dash,
      deps ? [ ],
    }:
    writeTextFile {
      name = "nix-prefetch-${tool}";
      executable = true;
      destination = "/bin/nix-prefetch-${tool}";
      text = /* sh */ ''
        #!${lib.getExe shell}
        set -eu
        export PATH="${lib.makeBinPath deps}:$PATH"
        export HOME="/homeless-shelter"
        exec ${lib.getExe shell} ${src} "$@"
      '';

      checkPhase = /* sh */ ''
        runHook preCheck
        ${stdenvNoCC.shellDryRun} "$target"
        runHook postCheck
      '';

      meta = {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with lib.maintainers; [
          bennofs
          toastal
        ];
        platforms = lib.platforms.unix;
        mainProgram = "nix-prefetch-${tool}";
      };
    };
in
rec {
  # No explicit dependency on Nix, as these can be used inside builders,
  # and thus will cause dependency loops. When used _outside_ builders,
  # we expect people to have a Nix implementation available ambiently.
  nix-prefetch-bzr = mkPrefetchScript {
    tool = "bzr";
    src = ../../../build-support/fetchbzr/nix-prefetch-bzr;
    deps = [
      breezy
      coreutils
      gnused
    ];
  };
  nix-prefetch-cvs = mkPrefetchScript {
    tool = "cvs";
    src = ../../../build-support/fetchcvs/nix-prefetch-cvs;
    deps = [
      coreutils
      cvs
    ];
  };
  nix-prefetch-darcs = mkPrefetchScript {
    tool = "darcs";
    src = ../../../build-support/fetchdarcs/nix-prefetch-darcs;
    deps = [
      cacert
      coreutils
      darcs
      gawk
      jq
    ];
  };
  nix-prefetch-git = mkPrefetchScript {
    tool = "git";
    src = ../../../build-support/fetchgit/nix-prefetch-git;
    shell = bash;
    deps = [
      coreutils
      findutils
      gawk
      git
      git-lfs
      gnused
    ];
  };
  nix-prefetch-hg = mkPrefetchScript {
    tool = "hg";
    src = ../../../build-support/fetchhg/nix-prefetch-hg;
    shell = bash;
    deps = [
      coreutils
      mercurial
    ];
  };
  nix-prefetch-svn = mkPrefetchScript {
    tool = "svn";
    src = ../../../build-support/fetchsvn/nix-prefetch-svn;
    deps = [
      coreutils
      gnugrep
      gnused
      subversion
    ];
  };
  nix-prefetch-pijul = mkPrefetchScript {
    tool = "pijul";
    src = ../../../build-support/fetchpijul/nix-prefetch-pijul;
    deps = [
      coreutils
      gawk
      pijul
      cacert
      jq
    ];
  };

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [
      nix-prefetch-bzr
      nix-prefetch-cvs
      nix-prefetch-darcs
      nix-prefetch-git
      nix-prefetch-hg
      nix-prefetch-svn
      nix-prefetch-pijul
    ];

    meta = {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with lib.maintainers; [ bennofs ];
      platforms = lib.platforms.unix;
    };
  };
}
