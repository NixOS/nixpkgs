{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, zope_testrunner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zope-contenttype";
  version = "4.6";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.contenttype";
    inherit version;
    hash = "sha256-NnVoeLxSWzY2TQ1b2ZovCw/TuaUND+m73Eqxs4rCOAA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zope_testrunner
  ];

  pythonImportsCheck = [
    "zope.contenttype"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.contenttype";
    description = "A utility module for content-type (MIME type) handling";
    changelog = "https://github.com/zopefoundation/zope.contenttype/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
