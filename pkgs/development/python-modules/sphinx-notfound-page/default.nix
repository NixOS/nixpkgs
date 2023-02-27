{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonImportsCheckHook
# documentation build dependencies
, sphinxHook
, sphinx-prompt
, sphinx-rtd-theme
, sphinx-tabs
, sphinxcontrib-autoapi
, sphinxemoji
# runtime dependencies
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-notfound-page";
  version = "0.8.3";
  format = "flit";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-notfound-page";
    rev = version;
    hash = "sha256-9iP6X2dqtMC3+CIrNI3fGDLL8xyXVAWNhN90DlMa9JU=";
  };

  nativeBuildInputs = [
    flit-core
    pythonImportsCheckHook
    sphinxHook
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinxcontrib-autoapi
    sphinxemoji
  ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "notfound" ];

  meta = with lib; {
    description = "A sphinx extension to create a custom 404 page with absolute URLs hardcoded";
    homepage = "https://github.com/readthedocs/sphinx-notfound-page";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
