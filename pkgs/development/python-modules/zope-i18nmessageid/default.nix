{ lib
, buildPythonPackage
, fetchPypi
, six
, zope_testrunner
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "5.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.i18nmessageid";
    inherit version;
    hash = "sha256-R7djR7gOCytmxIbuZvP4bFdJOiB1uFqfuAJpD6cwvZI=";
  };

  propagatedBuildInputs = [ six ];

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
