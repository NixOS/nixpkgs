{ stdenv
, buildPythonPackage
, fetchPypi
, zope_i18nmessageid
, zope_schema
, zope_testrunner
, manuel
}:

buildPythonPackage rec {
  pname = "zope.configuration";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e16747f9fd6b9d8f09d78edf2a6f539cad0fa4ad49d8deb9cf63447cc4168e1";
  };

  checkInputs = [ zope_testrunner manuel ];

  propagatedBuildInputs = [ zope_i18nmessageid zope_schema ];

  # Need to investigate how to run the tests with zope-testrunner
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = https://github.com/zopefoundation/zope.configuration;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
