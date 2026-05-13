{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xxhash";
  version = "3.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8BYqeLE6DXYXsoRbkMdjM50fHYK7BKSwf0q1NcxeBdY=";
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
