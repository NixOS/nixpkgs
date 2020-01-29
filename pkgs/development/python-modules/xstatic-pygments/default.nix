{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Pygments";
  version = "2.2.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1rm073ag1hgwlazl52mng62wvnayz7ckr5ki341shvp9db1x2n51";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = https://pygments.org;
    description = "pygments packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
