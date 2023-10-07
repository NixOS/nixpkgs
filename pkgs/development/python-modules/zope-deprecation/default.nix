{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-deprecation";
  version = "4.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.deprecation";
    inherit version;
    sha256 = "0d453338f04bacf91bbfba545d8bcdf529aa829e67b705eac8c1a7fdce66e2df";
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
