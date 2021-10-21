{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyserial-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "velbus-aio";
  version = "2021.10.6";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = pname;
    rev = version;
    sha256 = "sha256-98V+skgLCMBt6cnEa9kNM5rOm9q6+QYf3TJ9P8eroM8=";
  };

  propagatedBuildInputs = [
    backoff
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
