{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, zope-i18nmessageid
, zope-interface
, zope-schema
, pytestCheckHook
, zope-testing
, zope-testrunner
, manuel
}:

buildPythonPackage rec {
  pname = "zope-configuration";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.configuration";
    inherit version;
    hash = "sha256-I0tKGMcfazub9rzyJSZLrgFJrGjeoHsHLw9pmkzsJuc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    manuel
    pytestCheckHook
    zope-testing
    zope-testrunner
  ];

  propagatedBuildInputs = [
    zope-i18nmessageid
    zope-interface
    zope-schema
  ];

  # Need to investigate how to run the tests with zope-testrunner
  doCheck = false;

  pythonImportsCheck = [
    "zope.configuration"
  ];

  pythonNamespaces = [
    "zope"
  ];

  meta = with lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    changelog = "https://github.com/zopefoundation/zope.configuration/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
