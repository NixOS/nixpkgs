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
  version = "0.7.6";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gf3hNCXioaLiQ0fZWPe9PO2YQeId4ZLmWsSZ5WvjSk0=";
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
