{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-re2,
  pyyaml,
  pytestCheckHook,
  setuptools,
  ua-parser-builtins,
  ua-parser-rs,
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-KKQlM1AonRqanhWlWIqPMoD+AzDCdwAzBsAbhqpZ4cs=";
  };

  build-system = [
    pyyaml
    setuptools
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
    changelog = "https://github.com/ua-parser/uap-python/releases/tag/${version}";
    description = "Python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
