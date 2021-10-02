{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.7.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = version;
    sha256 = "149fgrqnwf8nyv3msj6p614zbdi7m7s785y3fvh8fm8k7lmgqk8w";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  pythonImportsCheck = [ "vt" ];

  meta = with lib; {
    description = "Python client library for VirusTotal";
    homepage = "https://virustotal.github.io/vt-py/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
