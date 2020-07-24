{ buildPythonPackage
, isPy27
, fetchPypi
, pytestrunner
, setuptools_scm
, singledispatch
, pytest
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
    pytestrunner
    setuptools_scm
  ];

  checkInputs = [
    pytest
  ] ++ lib.optionals isPy27 [ singledispatch ];

  meta = with lib; {
    description = "Library providing syntactic sugar for creating variant forms of a canonical function";
    homepage = "https://github.com/python-variants/variants";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
