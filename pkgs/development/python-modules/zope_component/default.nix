{ stdenv
, buildPythonPackage
, fetchPypi
, zope-deferredimport
, zope_deprecation
, zope_event
, zope-hookable
, zope_interface
, zope_configuration
, zope_i18nmessageid
}:

buildPythonPackage rec {
  pname = "zope.component";
  version = "4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec2afc5bbe611dcace98bb39822c122d44743d635dafc7315b9aef25097db9e6";
  };

  propagatedBuildInputs = [
    zope-deferredimport zope_deprecation zope_event zope-hookable zope_interface
    zope_configuration zope_i18nmessageid
  ];

  # ignore tests because of a circular dependency on zope_security
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/zopefoundation/zope.component;
    description = "Zope Component Architecture";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
