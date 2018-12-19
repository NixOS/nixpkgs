{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "uritemplate.py";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e0cdeb0f55ec18e1580974e8017cd188549aacc2aba664ae756adb390b9d45b4";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/uri-templates/uritemplate-py;
    description = "Python implementation of URI Template";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };

}
