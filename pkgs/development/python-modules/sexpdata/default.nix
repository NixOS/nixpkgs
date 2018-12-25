{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ac827a616c5e87ebb60fd6686fb86f8a166938c645f4089d92de3ffbdd494e0";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}
