{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  monarchmoney,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "typedmonarchmoney";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "monarchmoney-typed";
    tag = "v${version}";
    hash = "sha256-AM6d7oecKf5aG8zO3I6BGY3/rgtrdzNabCwX8AOlEs4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    monarchmoney
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "typedmonarchmoney" ];

  meta = {
    description = "Typed wrapper around the Monarch Money API";
    homepage = "https://github.com/jeeftor/monarchmoney-typed";
    changelog = "https://github.com/jeeftor/monarchmoney-typed/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
