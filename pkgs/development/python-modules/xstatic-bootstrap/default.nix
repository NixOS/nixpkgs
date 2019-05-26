{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootstrap";
  version = "3.3.7.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0c949e78e8cd77983fd803a68a98df0124e0c3a872fddb9ac8e6e5b4a487f131";
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
