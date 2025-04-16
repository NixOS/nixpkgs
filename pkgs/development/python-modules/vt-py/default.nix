{
  lib,
  aiofiles,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-py";
    tag = version;
    hash = "sha256-5go6O5V8mY1Ph3peF6ISJ63/cnhNtDIlgeLztp2zpkY=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  nativeCheckInputs = [
    flask
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vt" ];

  meta = with lib; {
    description = "Python client library for VirusTotal";
    homepage = "https://virustotal.github.io/vt-py/";
    changelog = "https://github.com/VirusTotal/vt-py/releases/tag//${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
