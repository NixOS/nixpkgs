{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, zope-i18nmessageid
, zope_interface
, zope_schema
, pytestCheckHook
, zope_testing
, zope_testrunner
, manuel
}:

buildPythonPackage rec {
  pname = "zope-configuration";
  version = "4.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.configuration";
    inherit version;
    hash = "sha256-giPqSvU5hmznqccwrH6xjlHRfrUVk6p3c7NZPI1tdgg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    manuel
    pytestCheckHook
    zope_testing
    zope_testrunner
  ];

  propagatedBuildInputs = [
    zope-i18nmessageid
    zope_interface
    zope_schema
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
