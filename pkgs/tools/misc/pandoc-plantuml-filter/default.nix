{ buildPythonApplication
, fetchPypi
, pandocfilters
, lib
}:

buildPythonApplication rec {
  pname = "pandoc-plantuml-filter";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08673mfwxsw6s52mgglbdz7ybb68svqyr3s9w97d7rifbwvvc9ia";
  };

  propagatedBuildInputs = [
    pandocfilters
  ];

  meta = with lib; {
    homepage = "https://github.com/timofurrer/pandoc-plantuml-filter";
    description = "Pandoc filter which converts PlantUML code blocks to PlantUML images";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
    mainProgram = "pandoc-plantuml";
  };
}
