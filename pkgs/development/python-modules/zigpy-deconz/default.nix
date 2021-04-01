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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = version;
    sha256 = "sha256-d/yAk8owMu+J1BzlwR5mzF9HkXiE6Kc81AznvsAboy8=";
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
