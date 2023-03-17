{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonImportsCheckHook
# documentation build dependencies
, sphinxHook
, sphinx-rtd-theme
, matplotlib
, ipython
# runtime dependencies
, sphinx
, beautifulsoup4
# check dependencies
, pytest
}:

buildPythonPackage rec {
  pname = "sphinx-codeautolink";
  version = "0.12.1";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "felix-hilden";
    repo = "sphinx-codeautolink";
    rev = "v${version}";
    hash = "sha256-x81jhYknJ6lsLxR5ZyuYNNz/zt0kto6bNyaeZmPKDIE=";
  };

  nativeBuildInputs = [
    pythonImportsCheckHook
    sphinxHook
    sphinx-rtd-theme
    matplotlib
    ipython
  ];

  sphinxRoot = "docs/src";

  propagatedBuildInputs = [ sphinx beautifulsoup4 ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "sphinx_codeautolink" ];

  meta = with lib; {
    description = "A sphinx extension that makes code examples clickable";
    homepage = "https://github.com/felix-hilden/sphinx-codeautolink";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
