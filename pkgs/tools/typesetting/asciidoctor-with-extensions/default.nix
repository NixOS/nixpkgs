{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  makeWrapper,
  withJava ? true,
  jre, # Used by asciidoctor-diagram for ditaa and PlantUML
}:

let
  path = lib.makeBinPath (lib.optional withJava jre);
in
bundlerApp rec {
  pname = "asciidoctor";
  gemdir = ./.;

  exes = [
    "asciidoctor"
    "asciidoctor-epub3"
    "asciidoctor-multipage"
    "asciidoctor-pdf"
    "asciidoctor-reducer"
    "asciidoctor-revealjs"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = lib.optionalString (path != "") (
    lib.concatMapStrings (exe: ''
      wrapProgram $out/bin/${exe} \
        --prefix PATH : ${path}
    '') exes
  );

  passthru = {
    updateScript = bundlerUpdateScript "asciidoctor-with-extensions";
  };

  meta = with lib; {
    description = "Faster Asciidoc processor written in Ruby, with many extensions enabled";
    homepage = "https://asciidoctor.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.unix;
  };
}
