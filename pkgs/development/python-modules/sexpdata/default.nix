{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Xb2Lq0y1QQeYw+UV9LBp1RNf+XdlqSbVRWSORFcN3M=";
  };

  doCheck = false;

  meta = with lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}
