{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyserial
, pyserial-asyncio
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2023.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j0NGeuxhtxmlpal9MpnlHqGv47uTVx1Lyfy9u0cEtYg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    backoff
    pyserial
    pyserial-asyncio
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "velbusaio"
  ];

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
