{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3000abee4c28daebad55da6c85f3cd07b8062ce48e2e9943c8da1b9667d48427";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
