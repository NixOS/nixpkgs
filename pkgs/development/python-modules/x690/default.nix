{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  t61codec,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "x690";
  version = "1.0.0post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exhuma";
    repo = "x690";
    tag = "v${version}";
    hash = "sha256-HNKZq6VfqYAih2SrhGChC2jaQ76dhzKM/Mcr6pVYFE4=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "t61codec"
  ];

  dependencies = [
    t61codec
  ];

  pythonImportsCheck = [ "x690" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: "<UnknownType 99 b'abc' TypeClass.APPLICATION/TypeNature.CONSTRUCTED/3>" != "<UnknownType 99 b'abc' application/constructed/3>"
    "test_repr"
  ];

  meta = {
    description = "Pure Python X.690 implementation";
    homepage = "https://github.com/exhuma/x690";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
