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
  version = "0.3.2";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "emojicodes";
    tag = "v${version}";
    hash = "sha256-2/2fOIxjF4vs90uqZyzfidrh+P/MHa+LTf1RsQYmgZ0=";
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

  meta = {
    description = "Extension to use emoji codes in your Sphinx documentation";
    homepage = "https://github.com/sphinx-contrib/emojicodes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
