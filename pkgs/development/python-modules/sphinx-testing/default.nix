{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  sphinx,
  six,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-testing";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-72YXdbVyLXsA9n/CKRBDF9NWN6T7RDS/LABa/fHaTQk=";
  };

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];
  propagatedBuildInputs = [
    sphinx
    six
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
  ];

  # Test failures https://github.com/sphinx-doc/sphinx-testing/issues/5
  doCheck = false;

  meta = {
    homepage = "https://github.com/sphinx-doc/sphinx-testing";
    license = lib.licenses.bsd2;
    description = "Testing utility classes and functions for Sphinx extensions";
  };
}
