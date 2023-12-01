{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

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
  version = "3.4.4";
  format = "pyproject";

  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "executablebooks";
    repo = "sphinx-tabs";
    rev = "refs/tags/v${version}";
    hash = "sha256-RcCADGJfwXP/U7Uws/uX+huaJzRDRUabQOnc9gqMUzM=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'docutils~=0.18.0' 'docutils'
  '';

  nativeBuildInputs = [
    setuptools
    sphinxHook
  ];

  propagatedBuildInputs = [
    sphinx
    pygments
    docutils
  ];

  nativeCheckInputs = [ pytest
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
