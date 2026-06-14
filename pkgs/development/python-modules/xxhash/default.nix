{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xxhash";
  version = "3.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bMTu+7VCpdb/1tcOqcUClXySXoAPmYxWMOzICdZwK64=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "xxhash" ];

  meta = {
    description = "Python Binding for xxHash";
    homepage = "https://github.com/ifduyue/python-xxhash";
    changelog = "https://github.com/ifduyue/python-xxhash/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ teh ];
  };
}
