{ stdenv, makeWrapper, git, subversion, mercurial, bazaar, cvs, unzip, curl }:

stdenv.mkDerivation {
  name = "nix-prefetch-scripts";

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    function copyScript {
      local name=nix-prefetch-$1;
      local src=$2;
      cp $src $out/bin/$name;
      for dep in ''${@:3}; do
        local exe=$dep/bin;
        local wrapArgs="$wrapArgs --suffix PATH : $exe"
      done
      wrapProgram $out/bin/$name $wrapArgs
    }

    copyScript "hg" ${../../../build-support/fetchhg/nix-prefetch-hg} ${mercurial}
    copyScript "git" ${../../../build-support/fetchgit/nix-prefetch-git} ${git}
    copyScript "svn" ${../../../build-support/fetchsvn/nix-prefetch-svn} ${subversion}
    copyScript "bzr" ${../../../build-support/fetchbzr/nix-prefetch-bzr} ${bazaar}
    copyScript "cvs" ${../../../build-support/fetchcvs/nix-prefetch-cvs} ${cvs}
    copyScript "zip" ${./nix-prefetch-zip} ${unzip} ${curl}
  '';

  meta = with stdenv.lib; {
    description = "Collection of all the nix-prefetch-* scripts which may be used to obtain source hashes";
    maintainers = with maintainers; [ bennofs ];
    platforms = with stdenv.lib.platforms; unix;
    # Quicker to build than to download, I hope
    hydraPlatforms = [];
  };
}
