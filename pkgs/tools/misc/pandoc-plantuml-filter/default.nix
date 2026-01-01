{
  lib,
  buildPythonApplication,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pandocfilters,
}:

buildPythonApplication rec {
  pname = "pandoc-plantuml-filter";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9qXeIZuCu44m9EoPCPL7MgEboEwN91OylLfbkwhkZYQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ pandocfilters ];

  meta = {
    homepage = "https://github.com/timofurrer/pandoc-plantuml-filter";
    description = "Pandoc filter which converts PlantUML code blocks to PlantUML images";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      cmcdragonkai
      l33tname
    ];
=======
    maintainers = with lib.maintainers; [ cmcdragonkai ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pandoc-plantuml";
  };
}
