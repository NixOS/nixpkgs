{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch2
, setuptools
, incremental
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-4nbTsVRqtoX4UhTrQS4HwoLtx0RO1VA8UewSAWOSsik=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/timmo001/system-bridge-models/commit/7cd506760fd47c0f3717b6fcfe127b673e3198f8.patch";
      hash = "sha256-i+GCcoyX07ii9Kj46dtAlT85jUKfF0KHEH9++UTjiik=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    incremental
  ];

  pythonImportsCheck = [ "systembridgemodels" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/timmo001/system-bridge-models/releases/tag/${version}";
    description = "This is the models package used by the System Bridge project";
    homepage = "https://github.com/timmo001/system-bridge-models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
