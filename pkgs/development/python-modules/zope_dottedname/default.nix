{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.dottedname";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mfWDqAKFhqtMIXlGE+QR0BDNCZF/RdqXa9/udI87++w=";
  };

  meta = with lib; {
    homepage = "http://pypi.python.org/pypi/zope.dottedname";
    description = "Resolver for Python dotted names";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
