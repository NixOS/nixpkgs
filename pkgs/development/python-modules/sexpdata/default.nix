{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sexpdata";
  version = "0.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb696bc66b35def5fb356de09481447dff4e9a3ed926823134e1d0f35eade428";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "S-expression parser for Python";
    homepage = "https://github.com/tkf/sexpdata";
    license = licenses.bsd0;
  };

}
