{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06x409cgr5im9cppzypj1kqy1fsry906vn5slv7i9hd7fshvd53g";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
