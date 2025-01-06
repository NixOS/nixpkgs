{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "zope.event";
  version = "4.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gdmIEwRvyGzEE242mP7mKKMoL5wyDbGGWMIXSSNfzoA=";
  };

  meta = {
    description = "Event publishing system";
    homepage = "https://pypi.org/project/zope.event/";
    license = lib.licenses.zpl20;
    maintainers = [ ];
  };
}
