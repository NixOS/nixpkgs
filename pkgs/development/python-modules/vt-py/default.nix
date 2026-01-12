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
  setuptools,
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-py";
    tag = version;
    hash = "sha256-CReFwX/7UCyFWVG/3hXwTVt92x+n+eu3FhvrKtDrgNU=";
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

  meta = {
    description = "Python client library for VirusTotal";
    homepage = "https://virustotal.github.io/vt-py/";
    changelog = "https://github.com/VirusTotal/vt-py/releases/tag//${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
