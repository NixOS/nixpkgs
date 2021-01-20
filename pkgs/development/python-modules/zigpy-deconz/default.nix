{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, zigpy
, pytestCheckHook
, pytest-asyncio
, asynctest
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = version;
    sha256 = "1p9mdsfc200iyszppcflazzfwqg4v8nqqwqsx114nip5km7a5s37";
  };

  propagatedBuildInputs = [ pyserial pyserial-asyncio zigpy ];
  checkInputs = [ pytestCheckHook pytest-asyncio asynctest ];

  meta = with lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu mvnetbiz ];
    platforms = platforms.linux;
  };
}
