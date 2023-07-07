{ buildPythonApplication
, drawio-headless
, fetchFromGitHub
, lib
, pandoc
, pandocfilters
, runCommand
, runtimeShell
, texlive
, writeScriptBin
, xvfb-run
}:

let
  version = "1.1";

  src = fetchFromGitHub {
    owner = "tfc";
    repo = "pandoc-drawio-filter";
    rev = version;
    sha256 = "sha256-2XJSAfxqEmmamWIAM3vZqi0mZjUUugmR3zWw8Imjadk=";
  };

  pandoc-drawio-filter = buildPythonApplication {
    pname = "pandoc-drawio-filter";

    inherit src version;

    propagatedBuildInputs = [
      drawio-headless
      pandocfilters
    ];

    passthru.tests.example-doc =
      let
        env = {
          nativeBuildInputs = [
            pandoc
            pandoc-drawio-filter
            texlive.combined.scheme-tetex
          ];
        };
      in
      runCommand "$pandoc-drawio-filter-example-doc.pdf" env ''
        cp -r ${src}/example/* .
        pandoc -F pandoc-drawio example.md -T pdf -o $out
      '';

    meta = with lib; {
      homepage = "https://github.com/tfc/pandoc-drawio-filter";
      description = "Pandoc filter which converts draw.io diagrams to PDF";
      license = licenses.mit;
      maintainers = with maintainers; [ tfc ];
    };
  };

in

pandoc-drawio-filter
