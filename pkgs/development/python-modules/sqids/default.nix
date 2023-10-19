{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqids";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qAY41kOp0m+mua/4bvVwuDW5p0EpwY675Ux3W1JsqbE=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqids" ];

  meta = with lib; {
    homepage = "https://sqids.org/python";
    description = "A library that lets you generate short YouTube-looking IDs from numbers";
    license = with licenses; mit;
    maintainers = with maintainers; [ panicgh ];
  };
}
