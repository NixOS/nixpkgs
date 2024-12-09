{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "teslemetry-stream";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-teslemetry-stream";
    rev = "v${version}";
    hash = "sha256-Ny68yiM0LS2U7zy6K2R35ZLm+Jo4s+HIFJjuqgL49E0=";
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
