{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  msgpack,
}:

buildPythonPackage rec {
  pname = "wslink";
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitware";
    repo = "wslink";
    tag = "v${version}";
    hash = "sha256-m820SiPu3fTAWGI74wtXm6b8oNn4W1wsthQZXAsg1VM=";
  };

  # add missing version string in dist-info
  postPatch = ''
    sed -i "/name *= */a\    version='${version}'," python/setup.py
  '';

  preConfigure = ''
    cd python
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    msgpack
  ];

  pythonImportsCheck = [ "wslink" ];

  # doCheck need interacting with the http server
  doCheck = false;

  meta = {
    description = "Python/JavaScript library for communicating over WebSocket";
    homepage = "https://github.com/Kitware/wslink";
    changelog = "https://github.com/Kitware/wslink/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
