{ lib
, buildPythonPackage
, fetchPypi
, zope_testrunner
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "6.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.i18nmessageid";
    inherit version;
    hash = "sha256-LVvOb7MfHOoO+iZEZJvIZ9KXIwPx272f/vzlsuueAXY=";
  };

  nativeCheckInputs = [
    unittestCheckHook
    zope_testrunner
  ];

  unittestFlagsArray = [
    "src/zope/i18nmessageid"
  ];

  pythonImportsCheck = [
    "zope.i18nmessageid"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
    description = "Message Identifiers for internationalization";
    changelog = "https://github.com/zopefoundation/zope.i18nmessageid/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
