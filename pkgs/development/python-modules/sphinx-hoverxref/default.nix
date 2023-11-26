{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonImportsCheckHook
# documentation build dependencies
, sphinxHook
, sphinx-notfound-page
, sphinx-prompt
, sphinx-rtd-theme
, sphinx-tabs
, sphinx-version-warning
, sphinx-autoapi
, sphinxcontrib-bibtex
, sphinxemoji
# runtime dependencies
, sphinx
, sphinxcontrib-jquery
}:

buildPythonPackage rec {
  pname = "sphinx-hoverxref";
  version = "1.3.0";
  format = "pyproject";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-hoverxref";
    rev = version;
    hash = "sha256-DJ+mHu9IeEYEyf/SD+nDNtWpTf6z7tQzG0ogaECDpkU=";
  };

  nativeBuildInputs = [
    flit-core
    pythonImportsCheckHook

    sphinxHook
    sphinx-notfound-page
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinx-version-warning
    sphinx-autoapi
    sphinxcontrib-bibtex
    sphinxemoji
  ];

  propagatedBuildInputs = [ sphinx sphinxcontrib-jquery ];

  pythonImportsCheck = [ "hoverxref" ];

  meta = with lib; {
    description = "A sphinx extension for creating tooltips on the cross references of the documentation";
    longDescription = ''
      sphinx-hoverxref is a Sphinx extension to show a floating window
      (tooltips or modal dialogues) on the cross references of the
      documentation embedding the content of the linked section on them.

      With sphinx-hoverxref, you don’t need to click a link to see what’s
      in there.
    '';
    homepage = "https://github.com/readthedocs/sphinx-hoverxref";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
