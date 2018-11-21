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
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gzbr0j6c2h0cqnpi2cjss38wrz1bcwx8xahl3vykgz5laid15l6";
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
