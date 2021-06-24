{ lib
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_schema
, zope_testrunner
, manuel
}:

buildPythonPackage rec {
  pname = "zope.configuration";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9f02bac44405ad1526399d6574b91d792f9694f9c67df8b64e91fe10fcddb3c";
  };

  checkInputs = [ zope_testrunner manuel ];

  propagatedBuildInputs = [ zope_i18nmessageid zope_schema ];

  # Need to investigate how to run the tests with zope-testrunner
  doCheck = false;

  meta = with lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
