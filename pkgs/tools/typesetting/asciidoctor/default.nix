{ lib, bundlerApp, makeWrapper, 
  # Optional dependencies, can be null
  epubcheck, kindlegen, 
  # For the update shell
  mkShell, bundix 
}:

let app = bundlerApp {
    pname = "asciidoctor";
    gemdir = ./.;

    exes = [
      "asciidoctor"
      "asciidoctor-pdf"
      "asciidoctor-safe"
      "asciidoctor-epub3"
    ];

    buildInputs = [ makeWrapper ];

    postBuild = ''
        wrapProgram "$out/bin/asciidoctor-epub3" \
          ${lib.optionalString (epubcheck != null) "--set EPUBCHECK ${epubcheck}/bin/epubcheck"} \
          ${lib.optionalString (kindlegen != null) "--set KINDLEGEN ${kindlegen}/bin/kindlegen"}
      '';

    meta = with lib; {
      description = "A faster Asciidoc processor written in Ruby";
      homepage = https://asciidoctor.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ gpyh ];
      platforms = platforms.unix;
    };
  };

  # Can't be defined directly in the passthru, since app.gems isn't defined at that point.
  shell = mkShell { 
    inputsFrom = lib.mapAttrs app.gems;
    buildInputs = [ bundix ]; 
  };
in app.overrideAttrs (attrs: { passthru = attrs.passthru // { updateShell = shell; }; })
