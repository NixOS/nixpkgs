{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.27.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18a7n85xv0qrab2ck94kw92ncjq2l8vl0k34pm22rjvd8h6gixil";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
