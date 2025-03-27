{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "scripttest";
  version = "2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xbFdNcRlwLxjcCvYS6Q2U+EXl+rtx31er4bvwgEpk2A=";
  };

  buildInputs = [ pytest ];

  # Tests are not included. See https://github.com/pypa/scripttest/issues/11
  doCheck = false;

  meta = with lib; {
    description = "Library for testing interactive command-line applications";
    homepage = "https://pypi.org/project/scripttest/";
    maintainers = [ ];
    license = licenses.mit;
  };
}
