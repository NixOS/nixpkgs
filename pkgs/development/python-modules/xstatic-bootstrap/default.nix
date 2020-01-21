{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootstrap";
  version = "4.1.3.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1800e6bb5fc687604d8a893eee8c7882d800a6f3d6721799016f99a47d1dac0f";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = https://getbootstrap.com;
    description = "Bootstrap packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
