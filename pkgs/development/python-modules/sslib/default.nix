{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  isPy3k,
}:

buildPythonPackage (finalAttrs: {
  pname = "sslib";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  disabled = !isPy3k;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-J5C/YJYbhoAuPFMAWws51tM2164M/nvKrnSSvqfMvyw=";
  };

  build-system = [ setuptools ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "sslib" ];

  meta = {
    homepage = "https://github.com/jqueiroz/python-sslib";
    description = "Python3 library for sharing secrets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jqueiroz ];
  };
})
