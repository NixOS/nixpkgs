{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, webencodings
# Check inputs
, pytest
, pytestrunner
, pytestcov
, pytest-flake8
, pytest-isort
}:

buildPythonPackage rec {
  pname = "tinycss2";
  version = "1.0.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kw84y09lggji4krkc58jyhsfj31w8npwhznr7lf19d0zbix09v4";
  };

  patches = [
    (
      fetchpatch {
        name = "tinycss2-fix-pytest-flake8-fail.patch";
        url = "https://github.com/Kozea/tinycss2/commit/6556604fb98c2153412384d6f0f705db2da1aa60.patch";
        sha256 = "1srvdzg1bak65fawd611rlskcgn5abmwmyjnk8qrrrasr554bc59";
      }
    )
  ];

  propagatedBuildInputs = [ webencodings ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
  };
}
