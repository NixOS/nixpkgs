{ lib
, buildPythonPackage
, fetchPypi
, six
, coverage
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope.i18nmessageid";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R7djR7gOCytmxIbuZvP4bFdJOiB1uFqfuAJpD6cwvZI=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ coverage zope_testrunner ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
    description = "Message Identifiers for internationalization";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
