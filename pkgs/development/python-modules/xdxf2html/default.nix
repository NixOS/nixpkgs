{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,
}:

buildPythonPackage rec {
  pname = "xdxf2html";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u2UaEALzD583+hbgwTItQOdGQ6GIhdVy79C2gfJwzlI=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "xdxf2html" ];

  meta = {
    description = "Python module for converting XDXF dictionary texts into HTML";
    homepage = "https://github.com/Crissium/python-xdxf2html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
