{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mbdyhqwlm4pcd0wr5haxypxm0kr8y46nc17696xmd4pvfmzk9wa";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
