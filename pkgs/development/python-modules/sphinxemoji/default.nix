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
  version = "0.3.1";
  format = "pyproject";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "emojicodes";
    tag = "v${version}";
    hash = "sha256-ss7snuXyT+tahc2GioB7qdGDqZdajEGdbaNt0aWF9ls=";
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
