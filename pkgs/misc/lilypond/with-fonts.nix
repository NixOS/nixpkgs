{
  lib,
  symlinkJoin,
  makeWrapper,
  lilypond,
  openlilylib-fonts,
}:

lib.appendToName "with-fonts" (symlinkJoin {
  inherit (lilypond)
    pname
    outputs
    version
    meta
    ;

  paths = [ lilypond ] ++ openlilylib-fonts.all;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for p in $out/bin/*; do
      wrapProgram "$p" --set LILYPOND_DATADIR "$out/share/lilypond/${lilypond.version}"
    done

    ln -s ${lilypond.man} $man
  '';
})
