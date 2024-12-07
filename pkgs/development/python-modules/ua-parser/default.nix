{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-re2,
  pyyaml,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  ua-parser-builtins,
  ua-parser-rs,
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    rev = "refs/tags/${version}";
    fetchSubmodules = true;
    hash = "sha256-byKtxmuYIsEYyuUmfnbLhfe7EKj0k7QGkK5HewiTiy4=";
  };

  build-system = [
    pyyaml
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ua-parser-builtins
  ];

  optional-dependencies = {
    yaml = [ pyyaml ];
    re2 = [ google-re2 ];
    regex = [ ua-parser-rs ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ua_parser" ];

  meta = {
    changelog = "https://github.com/ua-parser/uap-python/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
