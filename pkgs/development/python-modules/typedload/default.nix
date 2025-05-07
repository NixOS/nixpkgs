{ attrs
, buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
, python
, setuptools
,
}:

let
  typedload = buildPythonPackage rec {
    pname = "typedload";
    version = "2.37";
    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "DNYPufshGeAGQ7wwLs5nANoxRtFFpsRaOeLsgVHXQLE=";
    };

    meta = with lib; {
      homepage = "https://ltworf.github.io/typedload/";
      description = "Load and dump json-like data into typed data structures";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ppentchev ];
    };

    propagatedBuildInputs = [
      setuptools
    ];

    nativeCheckInputs = [
      attrs
      pytestCheckHook
    ];
    disabledTestPaths = [
    ] ++ lib.optionals (python.pythonOlder "3.10") [
      "tests/test_orunion.py"
    ] ++ lib.optionals (python.pythonOlder "3.12") [
      "tests/test_typealias.py"
    ];

    pythonImportsCheck = [ "typedload" ];
  };
in
typedload
