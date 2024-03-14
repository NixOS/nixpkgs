{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, incremental
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "systembridgemodels";
  version = "4.0.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "system-bridge-models";
    rev = "refs/tags/${version}";
    hash = "sha256-5rbj58E8iDu2Rjf0k9Y1UoF3hbN7ntkx6dm20HYpw6I=";
  };

  postPatch = ''
    substituteInPlace systembridgemodels/_version.py \
      --replace-fail ", dev=0" ""
  '';

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
