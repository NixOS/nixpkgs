{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1snkyc6ph0bnypqs5yjw35mx3f9ij4808r5i06gl2vhn1rfzgyh1";
  };

  meta = with stdenv.lib; {
    description = "A small python module for wake on lan";
    homepage = https://github.com/remcohaszing/pywakeonlan;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
