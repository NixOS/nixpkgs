{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  msgpack,
  cryptography,
}:

buildPythonPackage rec {
  pname = "wslink";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitware";
    repo = "wslink";
    tag = "v${version}";
    hash = "sha256-IFXxMN+OXJ/J2BSegxOBjE4iSA27pLyCpyyx4hmo9NU=";
  };

  sourceRoot = "${src.name}/python";

  # add missing version string to dist-info
  postPatch = ''
    sed -i "/name *= */a\    version='${version}'," setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    msgpack
  ];

  optional-dependencies = {
    ssl = [ cryptography ];
  };

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
