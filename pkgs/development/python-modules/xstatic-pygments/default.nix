{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Pygments";
  version = "1.6.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0fjqgg433wfdnswn7fad1g6k2x6mf24wfnay2j82j0fwgkdxrr7m";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = http://pygments.org;
    description = "pygments packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
