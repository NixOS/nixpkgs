{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery";
  version = "3.4.1.0";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0y2rhbasr7vdjbgi6x67cx97hwdnmv6m5difqqq59yb5n9zark1z";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage =  "https://jquery.org";
    description = "jquery packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
