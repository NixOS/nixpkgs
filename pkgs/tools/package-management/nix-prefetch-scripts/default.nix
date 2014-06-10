{ stdenv, makeWrapper, git, subversion, mercurial, bazaar, cvs }:

stdenv.mkDerivation {
  name = "nix-prefetch-scripts";

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    function copyScript {
      local name=nix-prefetch-$1;
      local src=$2;
      local exe=$3/bin;
      cp $src $out/bin/$name;
      wrapProgram $out/bin/$name --suffix PATH : "$exe"
    }

    copyScript "hg" ${../../../build-support/fetchhg/nix-prefetch-hg} ${mercurial}
    copyScript "git" ${../../../build-support/fetchgit/nix-prefetch-git} ${git}
    copyScript "svn" ${../../../build-support/fetchsvn/nix-prefetch-svn} ${subversion}
    copyScript "bzr" ${../../../build-support/fetchbzr/nix-prefetch-bzr} ${bazaar}
    copyScript "cvs" ${../../../build-support/fetchcvs/nix-prefetch-cvs} ${cvs}
  '';

  meta = with stdenv.lib; {
    description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
    maintainers = with maintainers; [ bennofs ];
    platforms = with stdenv.lib.platforms; unix;
    # Quicker to build than to download, I hope
    hydraPlatforms = [];
  };
}