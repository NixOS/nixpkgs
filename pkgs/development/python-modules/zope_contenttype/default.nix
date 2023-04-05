{ lib
, buildPythonPackage
, fetchPypi
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope.contenttype";
  version = "4.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NnVoeLxSWzY2TQ1b2ZovCw/TuaUND+m73Eqxs4rCOAA=";
  };

  nativeCheckInputs = [ zope_testrunner ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.contenttype";
    description = "A utility module for content-type (MIME type) handling";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
