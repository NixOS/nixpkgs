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
  version = "2023.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Cereal2nd";
    repo = pname;
    rev = version;
    hash = "sha256-xVELkmucrw1QazSR2XN6ldmzdTya/rWsQd1mRsLTcbU=";
    fetchSubmodules = true;
  };

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

  # Has a "20212.6.2" tag which is a typo — it should be "2022.6.2".
  # This makes the automatic updater try to downgrade to this version,
  # e.g. dabe0b38a4d391191e93efd70c6159ea034759eb
  # Upstream issue: https://github.com/Cereal2nd/velbus-aio/issues/82
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Python library to support the Velbus home automation system";
    homepage = "https://github.com/Cereal2nd/velbus-aio";
    changelog = "https://github.com/Cereal2nd/velbus-aio/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
