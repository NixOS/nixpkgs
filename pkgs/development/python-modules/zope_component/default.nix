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
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pQj5/vG29ShkYtM0DNif+rXHiZ3KBAEzcjnLa6fGuwo=";
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
