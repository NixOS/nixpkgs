{
  lib,
  aiohttp,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  ijson,
  ply,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "thriftpy2";
  version = "0.8.0b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = "thriftpy2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tOW6YXNuwBom7Xn5aP3F1o3aWV1vLJBI6llJlAhRQEs=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  dependencies = [
    ply
    ijson
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
  };

  # Not all needed files seems to be present
  doCheck = false;

  pythonImportsCheck = [ "thriftpy2" ];

  meta = {
    description = "Python module for Apache Thrift";
    homepage = "https://github.com/Thriftpy/thriftpy2";
    changelog = "https://github.com/Thriftpy/thriftpy2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
