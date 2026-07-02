{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  msgpack,
  cryptography,
}:

buildPythonPackage (finalAttrs: {
  pname = "wslink";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kitware";
    repo = "wslink";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1I8qCuqfv+pA3IP7b57PZ7vCsykpfJNG97NgJ+N5lE=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  # add missing version string to dist-info
  postPatch = ''
    sed -i "/name *= */a\    version='${finalAttrs.version}'," setup.py
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
    changelog = "https://github.com/Kitware/wslink/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
