{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic";
  version = "1.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "09npcsyf1ccygjs0qc8kdsv4qqy8gm1m6iv63g9y1fgbcry3vj8f";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = https://bitbucket.org/thomaswaldmann/xstatic;
    description = "Base packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
