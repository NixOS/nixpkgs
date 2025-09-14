{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
  six,
  pytestCheckHook,
  pretend,
}:

# We keep 20.4 because it uses setuptools instead of flit-core
# which requires Python 3 to build a universal wheel.

buildPythonPackage rec {
  pname = "packaging";
  version = "20.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8";
  };

  propagatedBuildInputs = [
    pyparsing
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pretend
  ];

  # Prevent circular dependency
  doCheck = false;

  meta = {
    description = "Core utilities for Python packages";
    homepage = "https://github.com/pypa/packaging";
    license = [
      lib.licenses.bsd2
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
