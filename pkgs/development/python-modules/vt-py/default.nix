{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonRelaxDepsHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.18.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-py";
    rev = "refs/tags/${version}";
    hash = "sha256-Zu4lUniXfKaZ1SvX3YCzMLa76HgUWpmddV2N9buNS3o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [ aiohttp ];

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
