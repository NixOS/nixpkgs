{ lib
, buildPythonPackage
, fetchPypi
, pretend
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "verspec";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xFBMppeyBWzbS/pxIUYfWg6BgJJVtBwD3aS6gjY3wB4=";
  };

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Import fail
    "test/test_specifiers.py"
  ];

  pythonImportsCheck = [
    "verspec"
  ];

  meta = with lib; {
    description = "Flexible version handling";
    homepage = "https://github.com/jimporter/verspec";
    changelog = "https://github.com/jimporter/averspec/releases/tag/v${version}";
    license = with licenses; [ bsd2 /* and */ asl20 ];
    maintainers = with maintainers; [ marsam ];
  };
}
