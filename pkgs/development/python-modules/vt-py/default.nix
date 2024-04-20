{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-py";
    rev = "refs/tags/${version}";
    hash = "sha256-QEe/ZoKM0uVH7Yqpgo7V17Odn4xqdEgdQeMVB+57xbA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "vt"
  ];

  meta = with lib; {
    description = "Python client library for VirusTotal";
    homepage = "https://virustotal.github.io/vt-py/";
    changelog = "https://github.com/VirusTotal/vt-py/releases/tag//${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
