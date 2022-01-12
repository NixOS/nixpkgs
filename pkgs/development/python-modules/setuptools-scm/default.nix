{ buildPythonPackage
, callPackage
, fetchPypi
, packaging
, tomli
, lib
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "6.3.2";

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    sha256 = "1wm0i27siyy1yqr9rv7lqvb65agay9051yi8jzmi8dgb3q4ai6m4";
  };

  propagatedBuildInputs = [
    packaging
    tomli
  ];

  pythonImportsCheck = [
    "setuptools_scm"
  ];

  # check in passhtru.tests.pytest to escape infinite recursion on pytest
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
