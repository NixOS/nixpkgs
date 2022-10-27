{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-jQuery";
  version = "3.5.1.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "e0ae8f8ec5bbd28045ba4bca06767a38bd5fc27cf9b71f434589f59370dcd323";
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
