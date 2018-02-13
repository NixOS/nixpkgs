{ stdenv, lib, bundlerApp, ruby, curl }:

bundlerApp {
  inherit ruby;
  pname = "asciidoctor";
  gemdir = ./.;

  exes = [
    "asciidoctor"
    "asciidoctor-bespoke"
    "asciidoctor-latex"
    "asciidoctor-pdf"
    "asciidoctor-safe"
  ];

  meta = with lib; {
    description = "A faster Asciidoc processor written in Ruby";
    homepage = http://asciidoctor.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ gpyh ];
    platforms = platforms.unix;
  };
}
