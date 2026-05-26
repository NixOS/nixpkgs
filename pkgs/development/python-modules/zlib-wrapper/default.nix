{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zlib-wrapper";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "zlib_wrapper";
    inherit version;
    hash = "sha256-Yxqc7fSDdnAPlGLzTbgcEQxiTKJDSJmPgm0eV62JiGQ=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "zlib_wrapper" ];

  meta = {
    description = "Wrapper around zlib with custom header crc32";
    homepage = "https://pypi.org/project/zlib_wrapper/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
