{ stdenv, lndir, symlinkJoin, makeWrapper
, lilypond, openlilylib-fonts
}:

stdenv.lib.appendToName "with-fonts" (symlinkJoin {
  inherit (lilypond) meta name version ;

  paths = [ lilypond ];

  buildInputs = [ makeWrapper lndir ];

  postBuild = ''
    for p in $out/bin/*; do
        wrapProgram "$p" --set LILYPOND_DATADIR "$datadir"
    done
  '';
})
