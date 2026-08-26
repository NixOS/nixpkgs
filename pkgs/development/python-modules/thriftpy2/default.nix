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

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = "thriftpy2";
    tag = "v${version}";
    hash = "sha256-vbNCPYWO/D+7/UJU/0ATdLzZ4lIPOKeBZ1sgWCdxx/c=";
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
    changelog = "https://github.com/Thriftpy/thriftpy2/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
