{ stdenv, buildPythonPackage, fetchFromGitHub
, aiohttp, crccheck, pycryptodome
, asynctest, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "zigpy";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy";
    rev = version;
    sha256 = "14a6hwsx9k1k775mx0g64l0nq6c6nsnqis9v157l9lx9vdqdzm4v";
  };

  buildInputs = [ asynctest pytest pytest-asyncio ];

  propagatedBuildInputs = [ aiohttp crccheck pycryptodome ];

  meta = with stdenv.lib; {
    description = "Library implementing a ZigBee stack";
    homepage = https://github.com/zigpy/zigpy;
    license = licenses.gpl3;
    maintainers = with maintainers; [ elseym ];
  };
}
