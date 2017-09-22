{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.17.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5472f4c95ab9b9fe9f5bf74ece3c986bfafa1f98ad9e1e296d4c35d291c97856";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
