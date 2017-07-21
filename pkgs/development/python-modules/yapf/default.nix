{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.11.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14kb9gxw39zhvrijhp066b4bm6bgv35iw56c394y4dyczpha0dij";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
