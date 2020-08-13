{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "toml";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f";
  };

  # This package has a test script (built for Travis) that involves a)
  # looking in the home directory for a binary test runner and b) using
  # git to download a test suite.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "a Python library for parsing and creating TOML";
    homepage = "https://github.com/uiri/toml";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
