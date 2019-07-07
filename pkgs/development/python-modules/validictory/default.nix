{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "validictory";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fim11vj990rmn59qd67knccjx1p4an7gavbgprpabsrb13bi1rs";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Validate dicts against a schema";
    homepage = https://github.com/sunlightlabs/validictory;
    license = licenses.mit;
  };

}
