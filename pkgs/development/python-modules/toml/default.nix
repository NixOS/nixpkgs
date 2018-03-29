{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "toml";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bdbpbip67wdm6c7xwc6mmbmskyradj4cdxn1iibj4fcx1nbv1lf";
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
