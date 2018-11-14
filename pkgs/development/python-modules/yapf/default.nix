{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0anwby0ydmyzcsgjc5dn1ryddwvii4dq61vck447q0n96npnzfyf";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
