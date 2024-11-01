{ buildPythonApplication
, fetchPypi
, pandocfilters
, panflute
, lib
, pandoc
, pandoc-acro
, texliveTeTeX
, runCommand
}:

let
  pname = "pandoc-acro";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JMfSQXX+BCGdFQYPFB+r08WRnhT3aXfnBNINROxCUA0=";
  };
in
buildPythonApplication {
  inherit pname version src;

  propagatedBuildInputs = [
    pandocfilters
    panflute
  ];

  # Something in the tests does not typecheck, but the tool works well.
  doCheck = false;

  passthru.tests.example-doc =
    let
        env = {
          nativeBuildInputs = [
            pandoc
            pandoc-acro
            (texliveTeTeX.withPackages (ps: with ps; [ acro translations ]))
          ];
        };
      in
      runCommand "pandoc-acro-example-docs" env ''
        set -euo pipefail
        exampleFile="${pname}-${version}/tests/example.md"
        metadataFile="${pname}-${version}/tests/metadata.yaml"
        tar --extract "--file=${src}" "$exampleFile" "$metadataFile"
        mkdir $out

        pandoc -F pandoc-acro "$exampleFile" "--metadata-file=$metadataFile" \
          -T pdf -o $out/example.pdf
        pandoc -F pandoc-acro  "$exampleFile" "--metadata-file=$metadataFile" \
          -T txt -o $out/example.txt

        ! grep -q "\+afaik" $out/example.txt
      '';

  meta = with lib; {
    homepage = "https://pypi.org/project/pandoc-acro/";
    description = "Pandoc filter which manages acronyms in Pandoc flavored Markdown sources";
    license = licenses.bsd2;
    maintainers = with maintainers; [ tfc ];
    mainProgram = "pandoc-acro";
  };
}
