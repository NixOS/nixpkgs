{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cfgv,
  identify,
  nodeenv,
  pre-commit,
  pyyaml,
  setuptools,
  virtualenv,
  wheel,
  docstring-parser,
  typing-extensions,
  numpy,
  pytest-benchmark,
  pytest-regressions,
  pytestCheckHook,
  tomli,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "simple-parsing";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lebrice";
    repo = "SimpleParsing";
    rev = "refs/tags/v${version}";
    hash = "sha256-KXKlXxAsh04WQDf4dBdcaQIWPeMa30wAbDdqg3iPdiI=";
    fetchSubmodules = true;
  };

  build-system = [
    cfgv
    identify
    nodeenv
    pre-commit
    pyyaml
    setuptools
    virtualenv
    wheel
  ];

  dependencies = [
    docstring-parser
    typing-extensions
  ];

  pythonImportsCheck = [ "simple_parsing" ];

  nativeCheckInputs = [
    numpy
    pytest-benchmark
    pytest-regressions
    pytestCheckHook
    tomli
    tomli-w
  ];

  meta = {
    description = "Simple, Elegant, Typed Argument Parsing with argparse";
    homepage = "https://github.com/lebrice/SimpleParsing";
    changelog = "https://github.com/lebrice/SimpleParsing/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
