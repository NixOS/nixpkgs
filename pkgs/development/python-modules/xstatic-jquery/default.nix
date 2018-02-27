{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery";
  version = "1.10.2.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "018kx4zijflcq8081xx6kmiqf748bsjdq7adij2k91bfp1mnlhc3";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage =  http://jquery.org;
    description = "jquery packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
