{ lib
, async-timeout
, asynctest
, buildPythonPackage
, coloredlogs
, fetchFromGitHub
, jsonschema
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytest-mock
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jki9qmjazh0by02c0w17dyaz0nl3gzjiy064mj6pi502d175831";
  };

  propagatedBuildInputs = [
    async-timeout
    coloredlogs
    jsonschema
    pyserial
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]  ++ lib.optionals (pythonOlder "3.8") [
    asynctest
  ];

  pythonImportsCheck = [ "zigpy_znp" ];

  meta = with lib; {
    description = "Python library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
