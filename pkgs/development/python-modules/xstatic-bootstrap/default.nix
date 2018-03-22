{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootstrap";
  version = "3.3.5.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0jzjq3d4vp2shd2n20f9y53jnnk1cvphkj1v0awgrf18qsy2bmin";
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
