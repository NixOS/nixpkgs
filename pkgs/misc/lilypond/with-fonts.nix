{ stdenv, lndir, symlinkJoin, makeWrapper
, lilypond, openlilylib-fonts
, fonts ? openlilylib-fonts.all
}:

stdenv.lib.appendToName "with-fonts" (symlinkJoin {
  inherit (lilypond) name version;

  paths = [ lilypond ];

  buildInputs = [ makeWrapper lndir ];

  postBuild = ''
    local datadir="$out/share/lilypond/${lilypond.version}"
    local fontsdir="$datadir/fonts"

    install -m755 -d "$fontsdir/otf"
    install -m755 -d "$fontsdir/svg"

    ${stdenv.lib.concatMapStrings (font: ''
          lndir -silent "${font}/otf" "$fontsdir/otf"
          lndir -silent "${font}/svg" "$fontsdir/svg"
      '') fonts}

      for p in $out/bin/*; do
          wrapProgram "$p" --set LILYPOND_DATADIR "$datadir"
      done
  '';

  inherit (lilypond) meta;
})
