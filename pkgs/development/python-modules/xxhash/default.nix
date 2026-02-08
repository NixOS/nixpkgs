{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xxhash";
  version = "3.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hPLK3flRycv43C4iqJ1Mz12GORrGQY/oHjxn0M9gtF8=";
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
