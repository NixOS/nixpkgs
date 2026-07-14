{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "standard-mailcap";
  version = "3.13.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-9mtQi5ufxP6xRonTrFC3oWFpWLbJraAmdQYozP3evgc=";
    sparseCheckout = [ "mailcap" ];
  };

  build-system = [ setuptools ];
  sourceRoot = "${src.name}/mailcap";

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "mailcap" ];

  meta = {
    description = "Standard library mailcap redistribution";
    homepage = "https://github.com/youknowone/python-deadlib";
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.lucc ];
  };
}
