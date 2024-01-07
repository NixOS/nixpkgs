{ lib
, buildPythonPackage
, fetchPypi
, zope-testrunner
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "6.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.i18nmessageid";
    inherit version;
    hash = "sha256-Rawm/chvq997ePHBvM/B1DctGlSDi7rt2p26dEStiUE=";
  };

  nativeCheckInputs = [
    unittestCheckHook
    zope-testrunner
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
