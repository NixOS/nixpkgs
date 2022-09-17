{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "typish";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "typish";
    rev = "7875850f55e2df8a9e2426e2d484ab618e347c7f";
    sha256 = "0mc5hw92f15mwd92rb2q9isc4wi7xq76449w7ph5bskcspas0wrf";
  };

  checkInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires a very old version of nptyping
    # which has a circular dependency on typish
    "tests/functions/test_instance_of.py"
  ];

  pythonImportsCheck = [
    "typish"
  ];

  meta = with lib; {
    description = "Python module for checking types of objects";
    homepage = "https://github.com/ramonhagenaars/typish";
    license = licenses.mit;
    maintainers = with maintainers; [ fmoda3 ];
  };
}
