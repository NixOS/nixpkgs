{ stdenv
, lndir
, lilypond
, openlilylib-fonts
, fonts ? openlilylib-fonts.all
}:

stdenv.mkDerivation {
  name = "${lilypond.name}-with-fonts";
  phases = "installPhase";
  buildInputs = fonts;
  nativeBuildInputs = [ lndir ];
  installPhase = ''
    local fontsdir=$out/share/lilypond/${lilypond.version}/fonts

    install -m755 -d $fontsdir/otf
    install -m755 -d $fontsdir/svg

    ${stdenv.lib.concatMapStrings (font: ''
        lndir -silent ${font}/otf $fontsdir/otf
        lndir -silent ${font}/svg $fontsdir/svg
      '') fonts}

      install -m755 -d $out/lib
      lndir -silent ${lilypond}/lib $out/lib
      install -m755 -d $out/share
      lndir -silent ${lilypond}/share $out/share

      install -m755 -Dt $out/bin ${lilypond}/bin/*

      for p in $out/bin/*; do
        substituteInPlace $p --replace "exec -a ${lilypond}" "exec -a $out"
      done
  '';
}
