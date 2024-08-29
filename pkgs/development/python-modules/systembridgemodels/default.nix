{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  incremental,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.2.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-FjHDd7nI30ChaClL0b1ME9Zv+DV0BiMsfgGOKQF/qBk=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail ">=" " #"

    substituteInPlace systembridgemodels/_version.py \
      --replace-fail ", dev=0" ""
  '';

  build-system = [
    incremental
    setuptools
  ];

  pythonRelaxDeps = [ "incremental" ];

  dependencies = [ incremental ];

  pythonImportsCheck = [ "systembridgemodels" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    "test_system"
    "test_update"
  ];

  pytestFlagsArray = [ "--snapshot-warn-unused" ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
