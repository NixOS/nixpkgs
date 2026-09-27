{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  twisted,
}:

buildPythonPackage (finalAttrs: {
  pname = "txdbus";
  version = "1.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "txdbus";
    inherit (finalAttrs) version;
    hash = "sha256-g3Wl+2ihIFTw3vka+ADIIfsiMpSTN3Vu2XX4jY6ivJc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    twisted
  ];
  pythonImportsCheck = [ "txdbus" ];

  meta = {
    description = "Native Python implementation of DBus for Twisted";
    homepage = "https://github.com/cocagne/txdbus";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
