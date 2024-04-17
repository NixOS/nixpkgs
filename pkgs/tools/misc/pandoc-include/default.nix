{ buildPythonApplication
, fetchFromGitHub
, lib
, natsort
, panflute
, lxml
, setuptools
}:

buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    rev = "refs/tags/v${version}";
    hash = "sha256-8TIGw6p9c61oSH3ld14rmeG6wZY9u9JHALImxXM3c3Y=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ natsort panflute lxml ];

  pythonImportsCheck = [ "pandoc_include.main" ];

  meta = with lib; {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = licenses.mit;
    maintainers = with maintainers; [ ppenguin DCsunset ];
    mainProgram = "pandoc-include";
  };
}
