{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic";
  version = "1.0.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "80b78dfe37bce6dee4343d64c65375a80bcf399b46dd47c0c7d56161568a23a8";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = "https://bitbucket.org/thomaswaldmann/xstatic";
    description = "Base packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
