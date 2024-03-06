{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch2
, setuptools
, incremental
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-9k85tqJO/YtkYncfNQBelmDkd3SYtf6SHURfumvqUo0=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/timmo001/system-bridge-models/commit/82fcee37cb302bc77384165b2ce10f2234c2a14a.patch";
      hash = "sha256-tZSaWVUPCJmuzkae9LBTdyZ3UINMvrSMbdS5AvbId8Q=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    incremental
  ];

  pythonImportsCheck = [ "systembridgemodels" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
