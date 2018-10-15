{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootstrap";
  version = "3.3.7.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0cgihyjb9rg6r2ddpzbjm31y0901vyc8m9h3v0zrhxydx1w9x50c";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = http://getbootstrap.com;
    description = "Bootstrap packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
