{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "toml";
  version = "0.10.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s72h0QjV3Zn0og0k2cNI6RxNt6sbdJIAve0vg5zL5o8=";
  };

  # This package has a test script (built for Travis) that involves a)
  # looking in the home directory for a binary test runner and b) using
  # git to download a test suite.
  doCheck = false;

  meta = with lib; {
    description = "Python library for parsing and creating TOML";
    homepage = "https://github.com/uiri/toml";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
