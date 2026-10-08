{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "teslemetry-stream";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "python-teslemetry-stream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ko9H0qhstD9VnR5707E9BUdJG2/KGGLsUxQpQ8F28y4=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "teslemetry_stream" ];

  meta = {
    changelog = "https://github.com/Teslemetry/python-teslemetry-stream/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for the Teslemetry Streaming API";
    homepage = "https://github.com/Teslemetry/python-teslemetry-stream";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
