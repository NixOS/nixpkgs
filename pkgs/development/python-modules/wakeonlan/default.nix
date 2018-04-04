{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e6013a17004809e676c150689abd94bcc0f12a37ad3fbce1f6270968f95ffa9";
  };

  meta = with stdenv.lib; {
    description = "A small python module for wake on lan";
    homepage = https://github.com/remcohaszing/pywakeonlan;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
