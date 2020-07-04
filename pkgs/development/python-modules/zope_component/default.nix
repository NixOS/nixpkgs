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
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9c7c27673d787faff8a83797ce34d6ebcae26a370e25bddb465ac2182766aca";
  };

  propagatedBuildInputs = [
    zope-deferredimport zope_deprecation zope_event zope-hookable zope_interface
    zope_configuration zope_i18nmessageid
  ];

  # ignore tests because of a circular dependency on zope_security
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/zopefoundation/zope.component";
    description = "Zope Component Architecture";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
