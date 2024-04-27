{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonRelaxDepsHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vt-py";
  version = "0.18.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "vt-py";
    rev = "refs/tags/${version}";
    hash = "sha256-Uspd422JlBKlsD/K7NciYhYUb12wInN/Z7zTw7aYP28=";
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
