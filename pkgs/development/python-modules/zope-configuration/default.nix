{ lib
, buildPythonPackage
, fetchPypi
, zope-i18nmessageid
, zope-schema
, zope-testrunner
, manuel
}:

buildPythonPackage rec {
  pname = "zope.configuration";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-giPqSvU5hmznqccwrH6xjlHRfrUVk6p3c7NZPI1tdgg=";
  };

  checkInputs = [ zope-testrunner manuel ];

  propagatedBuildInputs = [ zope-i18nmessageid zope-schema ];

  # Need to investigate how to run the tests with zope-testrunner
  doCheck = false;

  meta = with lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
