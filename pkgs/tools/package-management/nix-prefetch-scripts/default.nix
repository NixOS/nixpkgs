{
  lib,
  stdenv,
  makeWrapper,
  buildEnv,
  bashNonInteractive,
  breezy,
  cacert,
  coreutils,
  cvs,
  darcs,
  findutils,
  fossil,
  gawk,
  gitMinimal,
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
    tool: src: deps:
    stdenv.mkDerivation {
      inherit (lib.trivial) version;
      pname = "nix-prefetch-${tool}";

      strictDeps = true;
      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ bashNonInteractive ];

      dontUnpack = true;

      installPhase = ''
        install -vD ${src} $out/bin/$pname;
        wrapProgram $out/bin/$pname \
          --prefix PATH : ${lib.makeBinPath (deps ++ [ coreutils ])} \
          --set HOME /homeless-shelter
      '';

      preferLocalBuild = true;

      meta = {
        description = "Script used to obtain source hashes for fetch${tool}";
        maintainers = with lib.maintainers; [ bennofs ];
        platforms = lib.platforms.unix;
        mainProgram = "nix-prefetch-${tool}";
      };
    };
in
rec {
  # No explicit dependency on Nix, as these can be used inside builders,
  # and thus will cause dependency loops. When used _outside_ builders,
  # we expect people to have a Nix implementation available ambiently.
  nix-prefetch-bzr = mkPrefetchScript "bzr" ../../../build-support/fetchbzr/nix-prefetch-bzr [
    breezy
    gnused
  ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ../../../build-support/fetchcvs/nix-prefetch-cvs [ cvs ];
  nix-prefetch-darcs = mkPrefetchScript "darcs" ../../../build-support/fetchdarcs/nix-prefetch-darcs [
    darcs
    cacert
    gawk
    jq
  ];
  nix-prefetch-fossil =
    mkPrefetchScript "fossil" ../../../build-support/fetchfossil/nix-prefetch-fossil
      [
        fossil
        gnugrep
        gnused
      ];
  nix-prefetch-git = mkPrefetchScript "git" ../../../build-support/fetchgit/nix-prefetch-git [
    findutils
    gawk
    gitMinimal
    git-lfs
    gnused
  ];
  nix-prefetch-hg = mkPrefetchScript "hg" ../../../build-support/fetchhg/nix-prefetch-hg [
    mercurial
  ];
  nix-prefetch-svn = mkPrefetchScript "svn" ../../../build-support/fetchsvn/nix-prefetch-svn [
    gnugrep
    gnused
    subversion
  ];
  nix-prefetch-pijul = mkPrefetchScript "pijul" ../../../build-support/fetchpijul/nix-prefetch-pijul [
    gawk
    pijul
    cacert
    jq
  ];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [
      nix-prefetch-bzr
      nix-prefetch-cvs
      nix-prefetch-darcs
      nix-prefetch-fossil
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
