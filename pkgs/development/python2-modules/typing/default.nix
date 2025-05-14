{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  isPy3k,
  isPyPy,
  unittestCheckHook,
  pythonAtLeast,
}:

let
  testDir = if isPy3k then "src" else "python2";

in
buildPythonPackage rec {
  pname = "typing";
  version = "3.10.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b4ad211f54ddbf93e5901a9967b1e07720c1d1b78d596ac6a439641aa1b130";
  };

  disabled = pythonAtLeast "3.5";

  # Error for Python3.6: ImportError: cannot import name 'ann_module'
  # See https://github.com/python/typing/pull/280
  # Also, don't bother on PyPy: AssertionError: TypeError not raised
  doCheck = pythonOlder "3.6" && !isPyPy;

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    testDir
  ];

  meta = with lib; {
    description = "Backport of typing module to Python versions older than 3.5";
    homepage = "https://docs.python.org/3/library/typing.html";
    license = licenses.psfl;
  };
}
