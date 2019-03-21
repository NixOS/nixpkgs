{ stdenv, buildPythonApplication, fetchPypi, fetchpatch
, pytest, nose }:

buildPythonApplication rec {
  pname   = "sybil";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41d2f1dba8fd1d8ead5e9b1220b590fab8b0d1ca01d43da08555b1fb08d4d8e8";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/cjw296/sybil/commit/6461d8156cfb68bd073ec613a5a516916e97e549.patch;
      sha256 = "0aqny0i7l6g6d7vr025b90zz8wzszqdbmi05mp67dxw5xqjqvxj2";
    })
  ];

  checkInputs = [ pytest nose ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "Automated testing for the examples in your documentation.";
    homepage    = https://github.com/cjw296/sybil/;
    license     = licenses.mit;
  };
}
