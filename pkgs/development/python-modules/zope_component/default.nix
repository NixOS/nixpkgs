{ lib, stdenv
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
  version = "4.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "91628918218b3e6f6323de2a7b845e09ddc5cae131c034896c051b084bba3c92";
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
