{ lib, bundlerApp, makeWrapper,
  # Optional dependencies, can be null
  epubcheck,
  bundlerUpdateScript
}:

let
  app = bundlerApp {
    pname = "kramdown-asciidoc";
    gemdir = ./.;

    exes = [
      "kramdoc"
    ];

    # nativeBuildInputs = [ makeWrapper ];

    # postBuild = ''
    #     wrapProgram "$out/bin/asciidoctor-epub3" \
    #       ${lib.optionalString (epubcheck != null) "--set EPUBCHECK ${epubcheck}/bin/epubcheck"}
    #   '';

    # passthru = {
    #   updateScript = bundlerUpdateScript "kramdown-asciidoc";
    # };

    meta = with lib; {
      description = "Kramdown extension for converting Markdown documents to AsciiDoc";
      homepage = "https://asciidoctor.org/";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
      platforms = platforms.unix;
      mainProgram = "kramdoc";
    };
  };
in
  app
