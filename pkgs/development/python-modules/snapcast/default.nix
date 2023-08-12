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
  version = "2.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-snapcast";
    rev = "refs/tags/${version}";
    hash = "sha256-IFgSO0PjlFb4XJarx50Xnx6dF4tBKk3sLcoLWVdpnk8=";
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
