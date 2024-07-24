{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-i18nmessageid,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope.size";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sVRT40+Bb/VFmtg82TUCmqWBxqRTRj4DxeLZe9IKQyo=";
  };

  propagatedBuildInputs = [
    zope-i18nmessageid
    zope-interface
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
