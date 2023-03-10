{ lib
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
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32cbe426ba8fa7b62ce5b211f80f0718a0c749cc7ff09e3f4b43a57f7ccdf5e5";
  };

  propagatedBuildInputs = [
    zope-deferredimport zope_deprecation zope_event zope-hookable zope_interface
    zope_configuration zope_i18nmessageid
  ];

  # ignore tests because of a circular dependency on zope_security
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.component";
    description = "Zope Component Architecture";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
