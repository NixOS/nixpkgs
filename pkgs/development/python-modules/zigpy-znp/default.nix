{ stdenv
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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "zha-ng";
    repo = "zigpy-znp";
    rev = "v${version}";
    sha256 = "18dav2n5fqdigf8dl7gcqa9z8l6p2ig6l5q78gqg2wj7wjpncwyj";
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

  meta = with stdenv.lib; {
    description = "A library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zha-ng/zigpy-znp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
