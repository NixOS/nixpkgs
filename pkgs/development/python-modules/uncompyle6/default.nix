{ stdenv
, buildPythonPackage
, fetchPypi
, spark_parser
, xdis
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "2.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hx5sji6qjvnq1p0zhvyk5hgracpv2w6iar1j59qwllxv115ffi1";
  };

  propagatedBuildInputs = [ spark_parser xdis ];

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code deparser";
    homepage = https://github.com/rocky/python-uncompyle6/;
    license = licenses.mit;
  };

}
