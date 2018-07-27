{ stdenv, makeWrapper, buildEnv,
  git, subversion, mercurial, bazaar, cvs, gnused, coreutils, nix
}:

# these scripts should only be run on the build machine
# and as such the target and host for these scripts should
# be identical.
assert stdenv.targetPlatform == stdenv.hostPlatform;
# these scripts are also only supported on Linux and Darwin
assert stdenv.targetPlatform.isUnix;

let mkPrefetchScript = tool: src: deps:
  stdenv.mkDerivation {
    name = "nix-prefetch-${tool}";

    nativeBuildInputs = [ makeWrapper ];

    unpackPhase = ":";

    installPhase = ''
      install -vD ${src} $out/bin/$name;
      wrapProgram $out/bin/$name \
        --prefix PATH : ${stdenv.lib.makeBinPath (deps ++ [ gnused nix ])} \
        --set HOME /homeless-shelter
    '';

    preferLocalBuild = true;

    meta = with stdenv.lib; {
      description = "Script used to obtain source hashes for fetch${tool}";
      maintainers = with maintainers; [ bennofs ];
      platforms = stdenv.lib.platforms.unix;
    };
  };
in rec {
  nix-prefetch-bzr = mkPrefetchScript "bzr" ../../../build-support/fetchbzr/nix-prefetch-bzr [ bazaar ];
  nix-prefetch-cvs = mkPrefetchScript "cvs" ../../../build-support/fetchcvs/nix-prefetch-cvs [ cvs ];
  nix-prefetch-git = mkPrefetchScript "git" ../../../build-support/fetchgit/nix-prefetch-git [ git coreutils ];
  nix-prefetch-hg  = mkPrefetchScript "hg"  ../../../build-support/fetchhg/nix-prefetch-hg   [ mercurial ];
  nix-prefetch-svn = mkPrefetchScript "svn" ../../../build-support/fetchsvn/nix-prefetch-svn [ subversion ];

  nix-prefetch-scripts = buildEnv {
    name = "nix-prefetch-scripts";

    paths = [ nix-prefetch-bzr nix-prefetch-cvs nix-prefetch-git nix-prefetch-hg nix-prefetch-svn ];

    meta = with stdenv.lib; {
      description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
      maintainers = with maintainers; [ bennofs ];
      platforms = stdenv.lib.platforms.unix;
    };
  };
}
