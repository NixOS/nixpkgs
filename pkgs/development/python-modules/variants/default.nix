{ buildPythonPackage
, isPy27
, fetchPypi
, pytest-runner
, setuptools-scm
, pytestCheckHook
, six
, lib
}:

buildPythonPackage rec {
  pname = "variants";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version ;
    sha256 = "511f75b4cf7483c27e4d86d9accf2b5317267900c166d17636beeed118929b90";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
    six
  ];

  meta = with lib; {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
