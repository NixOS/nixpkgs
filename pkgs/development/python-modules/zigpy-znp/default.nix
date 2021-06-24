{ lib
, async-timeout
, asynctest
, buildPythonPackage
, coloredlogs
, coveralls
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytest-mock
, pytest-timeout
, pytestcov
, pytestCheckHook
, voluptuous
, zigpy }:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zha-ng";
    repo = "zigpy-znp";
    rev = "v${version}";
    sha256 = "1g5jssdnibhb4i4k1js9iy9w40cipf1gdnyp847x0bv6wblzx8rl";
  };

  propagatedBuildInputs = [
    async-timeout
    coloredlogs
    pyserial
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  checkInputs = [
    asynctest
    coveralls
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestcov
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zha-ng/zigpy-znp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
