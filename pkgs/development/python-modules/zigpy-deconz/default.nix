{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.15.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = version;
    sha256 = "sha256-QLEyEoX3gbrY/zvFmB1eah1wuc4bHH4S0D1B2WNHxaM=";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    zigpy
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_deconz"
  ];

  meta = with lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
