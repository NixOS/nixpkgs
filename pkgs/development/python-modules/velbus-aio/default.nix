{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyserial
, pyserial-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2021.11.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = pname;
    rev = version;
    sha256 = "sha256-itaYSfZm+/vF/tKRO2BW4qXrDXP0YfBrKiq9bMGFj0M=";
  };

  propagatedBuildInputs = [
    backoff
    pyserial
    pyserial-asyncio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "velbusaio"
  ];

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
