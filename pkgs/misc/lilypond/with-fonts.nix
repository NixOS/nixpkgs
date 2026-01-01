{
  lib,
  symlinkJoin,
  makeWrapper,
  lilypond,
  openlilylib-fonts,
}:

lib.appendToName "with-fonts" (symlinkJoin {
<<<<<<< HEAD
  inherit (lilypond)
    pname
    outputs
    version
    meta
    ;
=======
  inherit (lilypond) meta name version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  paths = [ lilypond ] ++ openlilylib-fonts.all;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for p in $out/bin/*; do
<<<<<<< HEAD
      wrapProgram "$p" --set LILYPOND_DATADIR "$out/share/lilypond/${lilypond.version}"
    done

    ln -s ${lilypond.man} $man
=======
        wrapProgram "$p" --set LILYPOND_DATADIR "$out/share/lilypond/${lilypond.version}"
    done
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';
})
