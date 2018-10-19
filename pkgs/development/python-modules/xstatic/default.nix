{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic";
  version = "1.0.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1a13i9b62qfmqz04gpa6kcwwy2x8fm9wcr1x6kjdxrmw6zz8vdw0";
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
