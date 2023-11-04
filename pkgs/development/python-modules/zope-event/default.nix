{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-event";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.event";
    inherit version;
    hash = "sha256-usRA2NmJG0Bo4rWixeLJdlqd92KUS9ppVflrubkeZ80=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/zope/event/tests.py"
  ];

  pythonImportsCheck = [
    "zope.event"
  ];

  pythonNamespaces = [
    "zope"
  ];

  meta = with lib; {
    description = "An event publishing system";
    homepage = "https://pypi.org/project/zope.event/";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${src}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
