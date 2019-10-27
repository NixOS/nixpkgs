{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.4.2";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "46c89ebb683f473ffe2aab0ed9f12581d4d078308a3cb3765d79c6b2317b0109";
  };

  meta = with stdenv.lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = https://github.com/jupyter/testpath;
  };

}
