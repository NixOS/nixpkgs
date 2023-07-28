{ lib
, buildPythonPackage
, fetchPypi
, zope_configuration
, zope-deferredimport
, zope_deprecation
, zope_event
, zope-hookable
, zope_i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-component";
  version = "5.1.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.component";
    inherit version;
    hash = "sha256-pQj5/vG29ShkYtM0DNif+rXHiZ3KBAEzcjnLa6fGuwo=";
  };

  propagatedBuildInputs = [
    zope_configuration
    zope-deferredimport
    zope_deprecation
    zope_event
    zope-hookable
    zope_i18nmessageid
    zope_interface
  ];

  # ignore tests because of a circular dependency on zope_security
  doCheck = false;

  pythonImportsCheck = [
    "zope.component"
  ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.component";
    description = "Zope Component Architecture";
    changelog = "https://github.com/zopefoundation/zope.component/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
