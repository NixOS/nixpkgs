{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, webencodings
# Check inputs
, pytest
, pytest-runner
, pytest-cov
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

  checkInputs = [ pytest pytest-runner pytest-cov pytest-flake8 pytest-isort ];

  # https://github.com/PyCQA/pycodestyle/issues/598
  preCheck = ''
    printf "[flake8]\nignore=W504,E741,E126" >> setup.cfg
  '';

  meta = with lib; {
    description = "Low-level CSS parser for Python";
    homepage = "https://github.com/Kozea/tinycss2";
    license = licenses.bsd3;
  };
}
