{
  lib,
  antlr4-python3-runtime,
  buildPythonPackage,
  fetchFromGitHub,
  pep517,
  pythonOlder,
  pyyaml,
  setuptools,
  setuptools-scm,
  sphinx,
  svglib,
  wheel,
}:

buildPythonPackage rec {
  pname = "sphinx-a4doc";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "taminomara";
    repo = "sphinx-a4doc";
    rev = "refs/tags/v${version}";
    hash = "sha256-bFK+8E3y3Xoo3Yd+oucMH0+GWdPkMRWC/6I6gYqCfew=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeBuildInputs = [
    pep517
  ];

  dependencies = [
    antlr4-python3-runtime
    pyyaml
    sphinx
    svglib
  ];

  pythonRelaxDeps = [ "antlr4-python3-runtime" ];

  pythonImportsCheck = [ "sphinx_a4doc" ];

  meta = {
    description = "Sphinx domain and autodoc for Antlr4 grammars";
    homepage = "https://taminomara.github.io/sphinx-a4doc/";
    changelog = "https://github.com/taminomara/sphinx-a4doc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
