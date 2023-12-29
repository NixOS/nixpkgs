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
, sphinx-autoapi
, sphinxemoji
# runtime dependencies
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-notfound-page";
  version = "1.0.0";
  format = "pyproject";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-notfound-page";
    rev = version;
    hash = "sha256-tG71UuYbdlWNgq6Y5xRH3aWc9/eTr/RlsRNWSUjrbBE=";
  };

  nativeBuildInputs = [
    flit-core
    pythonImportsCheckHook
    sphinxHook
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinx-autoapi
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
