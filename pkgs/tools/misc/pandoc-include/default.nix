{
  buildPythonApplication,
  fetchFromGitHub,
  lib,
  natsort,
  panflute,
  lxml,
  setuptools,
}:

buildPythonApplication rec {
  pname = "pandoc-include";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DCsunset";
    repo = "pandoc-include";
    rev = "refs/tags/v${version}";
    hash = "sha256-8gG1xkDuIN007uYSwSWgsDW4IFVIE44v3j7FN0RaZwU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    natsort
    panflute
    lxml
  ];

  pythonImportsCheck = [ "pandoc_include.main" ];

  meta = with lib; {
    description = "Pandoc filter to allow file and header includes";
    homepage = "https://github.com/DCsunset/pandoc-include";
    license = licenses.mit;
    maintainers = with maintainers; [
      ppenguin
      DCsunset
    ];
    mainProgram = "pandoc-include";
  };
}
