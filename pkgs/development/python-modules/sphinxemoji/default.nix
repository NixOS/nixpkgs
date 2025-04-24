{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "sphinxemoji";
  version = "0.2.0";
  format = "pyproject";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "emojicodes";
    rev = "refs/tags/v${version}";
    hash = "sha256-TLhjpJpUIoDAe3RZ/7sjTgdW+5s7OpMEd1/w0NyCQ3A=";
  };

  nativeBuildInputs = [
    setuptools
    sphinxHook
  ];

  propagatedBuildInputs = [
    sphinx
    # sphinxemoji.py imports pkg_resources directly
    setuptools
  ];

  pythonImportsCheck = [ "sphinxemoji" ];

  meta = with lib; {
    description = "Extension to use emoji codes in your Sphinx documentation";
    homepage = "https://github.com/sphinx-contrib/emojicodes";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
