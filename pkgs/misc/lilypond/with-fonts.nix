{ lib, lndir, symlinkJoin, makeWrapper
, lilypond, openlilylib-fonts
}:

lib.appendToName "with-fonts" (symlinkJoin {
  inherit (lilypond) meta name version ;

  paths = [ lilypond ] ++ openlilylib-fonts.all;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lndir ];

  postBuild = ''
    for p in $out/bin/*; do
        wrapProgram "$p" --set LILYPOND_DATADIR "$datadir"
    done
  '';
})
