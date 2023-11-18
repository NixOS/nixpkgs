{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.deprecation";
    inherit version;
    hash = "sha256-t8MtM5IDayFFxAsxA+cyLbaGYqsJtyZ6/hUyqdk/ZA8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/zope/deprecation/tests.py"
  ];

  pythonImportsCheck = [
    "zope.deprecation"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.deprecation";
    description = "Zope Deprecation Infrastructure";
    changelog = "https://github.com/zopefoundation/zope.deprecation/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ domenkozar ];
  };

}
