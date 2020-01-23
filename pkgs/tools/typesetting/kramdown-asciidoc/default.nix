{ lib, bundlerApp, makeWrapper,
  # Optional dependencies, can be null
  epubcheck, kindlegen,
  bundlerUpdateScript
}:

let
  app = bundlerApp {
    pname = "kramdown-asciidoc";
    gemdir = ./.;

    exes = [
      "kramdoc"
    ];

    # buildInputs = [ makeWrapper ];

    # postBuild = ''
    #     wrapProgram "$out/bin/asciidoctor-epub3" \
    #       ${lib.optionalString (epubcheck != null) "--set EPUBCHECK ${epubcheck}/bin/epubcheck"} \
    #       ${lib.optionalString (kindlegen != null) "--set KINDLEGEN ${kindlegen}/bin/kindlegen"}
    #   '';

    # passthru = {
    #   updateScript = bundlerUpdateScript "kramdown-asciidoc";
    # };

    meta = with lib; {
      description = "A kramdown extension for converting Markdown documents to AsciiDoc.";
      homepage = https://asciidoctor.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
    };
  };
in
  app
