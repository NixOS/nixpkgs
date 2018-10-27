{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "validictory";
  version = "1.0.0a2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c02388a70f5b854e71e2e09bd6d762a2d8c2a017557562e866d8ffafb0934b07";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Validate dicts against a schema";
    homepage = https://github.com/sunlightlabs/validictory;
    license = licenses.mit;
  };

}
