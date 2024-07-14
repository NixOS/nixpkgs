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
    hash = "sha256-Kia2N18u5tNO4kmP7PHWyKzlz2+LvldF0Ybrzl0dxyA=";
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
