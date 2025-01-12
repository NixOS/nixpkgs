{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "teslemetry-stream";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-teslemetry-stream";
    rev = "v${version}";
    hash = "sha256-hKGYZYRfI4FikTPsf7Wy0gOA+dCiMdlpWtEb/Gn1y7s=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "teslemetry_stream" ];

  meta = {
    changelog = "https://github.com/Teslemetry/python-teslemetry-stream/releases/tag/v${version}";
    description = "Python library for the Teslemetry Streaming API";
    homepage = "https://github.com/Teslemetry/python-teslemetry-stream";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
