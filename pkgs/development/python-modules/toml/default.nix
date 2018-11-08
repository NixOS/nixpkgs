{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "toml";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "380178cde50a6a79f9d2cf6f42a62a5174febe5eea4126fe4038785f1d888d42";
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
