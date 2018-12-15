{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "f16b2cb3b03e1ada4fb0200b265a4446f92f3ba4b9d88ace34f51c54ab6d294e";
  };

  meta = with stdenv.lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = https://github.com/jupyter/testpath;
  };

}
