{ lib
, buildPythonPackage
, construct
, packaging
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "snapcast";
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-snapcast";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-IFgSO0PjlFb4XJarx50Xnx6dF4tBKk3sLcoLWVdpnk8=";
=======
    hash = "sha256-kUUKDcHnWA+saqQM7aCfW9NmhG6DYsB21tlEQ3cYNs4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    construct
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "snapcast"
  ];

  disabledTests = [
    # AssertionError and TypeError
    "test_stream_setmeta"
    "est_stream_setproperty"
  ];

  meta = with lib; {
    description = "Control Snapcast, a multi-room synchronous audio solution";
    homepage = "https://github.com/happyleavesaoc/python-snapcast/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
