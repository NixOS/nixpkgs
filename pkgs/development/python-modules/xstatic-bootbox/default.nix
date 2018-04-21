{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootbox";
  version = "4.3.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0wks1lsqngn3gvlhzrvaan1zj8w4wr58xi0pfqhrzckbghvvr0gj";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = http://bootboxjs.com;
    description = "Bootboxjs packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
