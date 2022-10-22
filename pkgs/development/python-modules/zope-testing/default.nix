{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, zope-interface
, zope-exceptions
, zope-location
}:

buildPythonPackage rec {
  pname = "zope.testing";
  version = "4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O25ZBsrd0UjCP+lY5qrj+tyKCKilP3R9l5HC2BNe5W4=";
  };

  doCheck = !isPyPy;

  propagatedBuildInputs = [ zope-interface zope-exceptions zope-location ];

  meta = with lib; {
    description = "Zope testing helpers";
    homepage =  "http://pypi.python.org/pypi/zope.testing";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
