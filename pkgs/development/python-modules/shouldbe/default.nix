{ lib
, buildPythonPackage
, pythonAtLeast
, fetchPypi
, nose
, forbiddenfruit
}:

buildPythonPackage rec {
  version = "0.1.2";
  pname = "shouldbe";
  # incompatible, https://github.com/DirectXMan12/should_be/issues/4
  disabled = pythonAtLeast "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16zbvjxf71dl4yfbgcr6idyim3mdrfvix1dv8b95p0s9z07372pj";
  };

  nativeCheckInputs = [ nose ];
  propagatedBuildInputs = [ forbiddenfruit ];

  meta = with lib; {
    description = "Python Assertion Helpers inspired by Shouldly";
    homepage =  "https://pypi.python.org/pypi/shouldbe/";
    license = licenses.mit;
  };

}
