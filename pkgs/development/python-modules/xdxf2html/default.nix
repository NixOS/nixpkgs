{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,
}:

buildPythonPackage rec {
  pname = "xdxf2html";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ux622mch+sc6LzaYxbt35JGRL5mrnn/Tk7nrO5Z03xU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "xdxf2html" ];

  meta = with lib; {
    description = "Python module for converting XDXF dictionary texts into HTML";
    homepage = "https://github.com/Crissium/python-xdxf2html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vizid ];
  };
}
