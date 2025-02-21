{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "teslemetry-stream";
  version = "0.6.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-teslemetry-stream";
    tag = "v${version}";
    hash = "sha256-0Ca8p5xuzpSfZhtTYZUgbdNHXmnn9RLOGMTSYKfnUZg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "teslemetry_stream" ];

  meta = {
    changelog = "https://github.com/Teslemetry/python-teslemetry-stream/releases/tag/${src.tag}";
    description = "Python library for the Teslemetry Streaming API";
    homepage = "https://github.com/Teslemetry/python-teslemetry-stream";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
