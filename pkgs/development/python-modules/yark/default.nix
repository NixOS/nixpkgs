{ lib
, buildPythonPackage
, click
, colorama
, fetchPypi
, flask
, poetry-core
, progress
, pythonOlder
, pythonRelaxDepsHook
, requests
, yt-dlp
}:

buildPythonPackage rec {
  pname = "yark";
  version = "1.2.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y1fWHpvrqGuBPyJ2dO2y0W2zhEgcTJABtkOAoZ7uyZU=";
  };

  pythonRelaxDeps = [
    "requests"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    click
    colorama
    flask
    progress
    requests
    yt-dlp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "yark"
  ];

  meta = with lib; {
    description = "Module for YouTube archiving";
    homepage = "https://github.com/Owez/yark";
    changelog = "https://github.com/Owez/yark/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
