{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqids";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8P7/vY0kb7ouUCpgGU4g0Xb77BtSeQVt6nkdcogD50=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

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
