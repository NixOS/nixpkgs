{ lib, bundlerApp, makeWrapper,
  # Optional dependencies, can be null
  epubcheck,
  bundlerUpdateScript
}:

let
  app = bundlerApp {
    pname = "asciidoctor";
    gemdir = ./.;

    exes = [
      "asciidoctor"
      "asciidoctor-pdf"
      "asciidoctor-epub3"
      "asciidoctor-revealjs"
    ];

    buildInputs = [ makeWrapper ];

    postBuild = ''
        wrapProgram "$out/bin/asciidoctor-epub3" \
          ${lib.optionalString (epubcheck != null) "--set EPUBCHECK ${epubcheck}/bin/epubcheck"}
      '';

    passthru = {
      updateScript = bundlerUpdateScript "asciidoctor";
    };

    meta = with lib; {
      description = "A faster Asciidoc processor written in Ruby";
      homepage = "https://asciidoctor.org/";
      license = licenses.mit;
      maintainers = with maintainers; [ gpyh nicknovitski ];
      platforms = platforms.unix;
    };
  };
in
  app
