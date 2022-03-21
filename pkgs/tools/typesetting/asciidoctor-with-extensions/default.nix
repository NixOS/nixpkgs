{ lib
, bundlerApp
, bundlerUpdateScript
, makeWrapper
}:

bundlerApp {
  pname = "asciidoctor";
  gemdir = ./.;

  exes = [
    "asciidoctor"
    "asciidoctor-epub3"
    "asciidoctor-multipage"
    "asciidoctor-pdf"
    "asciidoctor-revealjs"
  ];

  passthru = {
    updateScript = bundlerUpdateScript "asciidoctor-with-extensions";
  };

  meta = with lib; {
    description = "A faster Asciidoc processor written in Ruby, with many extensions enabled";
    homepage = "https://asciidoctor.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.unix;
  };
}
