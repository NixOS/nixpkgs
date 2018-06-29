{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a98a6eacca64d2b920558f4a2f78150db9474de821227e60deaa29f186121c63";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
