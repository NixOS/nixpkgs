{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wptserve";
  version = "1.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rkq4dpl41hx64m3ad0bwn0r5i7sf8qpgazgkq905j3wgk5aaspg";
  };

  propagatedBuildInputs = [ ];

  meta = {
    description = "A webserver intended for web browser testing";
    homepage = " http://wptserve.readthedocs.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
