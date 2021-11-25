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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = version;
    sha256 = "sha256-9rxdnY5tMtPJLE/lRaphNR1L1vdhAxnIDoh8xCHmzjc=";
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
