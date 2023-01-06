{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonImportsCheckHook
# documentation build dependencies
, sphinxHook
# runtime dependencies
, sphinx
, pygments
, docutils
# test dependencies
, pytest
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "sphinx-tabs";
  version = "3.4.1";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-tabs";
    rev = "v${version}";
    hash = "sha256-5lpo7NRCksXJOdbLSFjDxQV/BsxRBb93lA6tavz6YEs=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'docutils~=0.18.0' 'docutils'
  '';

  nativeBuildInputs = [
    pythonImportsCheckHook
    sphinxHook
  ];

  propagatedBuildInputs = [
    sphinx
    pygments
    docutils
  ];

  checkInputs = [ pytest
    beautifulsoup4
  ];

  pythonImportsCheck = [ "sphinx_tabs" ];

  meta = with lib; {
    description = "A sphinx extension for creating tabbed content when building HTML.";
    homepage = "https://github.com/executablebooks/sphinx-tabs";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
