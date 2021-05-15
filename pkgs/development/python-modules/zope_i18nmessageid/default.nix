{ lib
, buildPythonPackage
, fetchPypi
, six
, coverage
, zope_testrunner
}:

buildPythonPackage rec {
  pname = "zope.i18nmessageid";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9534142b684c986f5303f469573978e5a340f05ba2eee4f872933f1c38b1b059";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ coverage zope_testrunner ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
    description = "Message Identifiers for internationalization";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
