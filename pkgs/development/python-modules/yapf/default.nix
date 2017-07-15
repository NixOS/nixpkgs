{
stdenv, lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.11.0";
  name = "${pname}-${version}";

  meta = {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siddharthist ];
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "14kb9gxw39zhvrijhp066b4bm6bgv35iw56c394y4dyczpha0dij";
  };
}
