{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "scripttest";
  version = "2.0.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pgZ/H+rfSy7T5ZSwsy5BWJZA5/o5dHZapj1QhSDAv9w=";
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
