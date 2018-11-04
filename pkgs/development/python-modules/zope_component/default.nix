{ stdenv
, buildPythonPackage
, fetchPypi
, zope_configuration
, zope_event
, zope_i18nmessageid
, zope_interface
, zope_testing
}:

buildPythonPackage rec {
  pname = "zope.component";
  version = "4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6edfd626c3b593b72895a8cfcf79bff41f4619194ce996a85bce31ac02b94e55";
  };

  propagatedBuildInputs = [ zope_configuration zope_event zope_i18nmessageid zope_interface zope_testing ];

  # ignore tests because of a circular dependency on zope_security
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.component;
    description = "Zope Component Architecture";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
