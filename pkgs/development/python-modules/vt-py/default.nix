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
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = pname;
    rev = version;
    sha256 = "1yjrhwy2m819yda70ir6h7jsndradaw9a4pxjl8ys8p909vljvgx";
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

  pythonImportsCheck = [
    "vt"
  ];

  meta = with lib; {
    description = "Python client library for VirusTotal";
    homepage = "https://virustotal.github.io/vt-py/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
