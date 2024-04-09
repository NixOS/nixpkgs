{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, incremental
, pytestCheckHook
, syrupy
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-2vJrH67vhUcNIAC5B0HKUD7sBdiB+suWxLlfcpBn6PM=";
  };

  postPatch = ''
    substituteInPlace systembridgemodels/_version.py \
      --replace-fail ", dev=0" ""
    substituteInPlace tests/__snapshots__/test_update.ambr \
      --replace-fail "4.1.1.dev0" "4.2.0"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    incremental
  ];

  pythonImportsCheck = [ "systembridgemodels" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
