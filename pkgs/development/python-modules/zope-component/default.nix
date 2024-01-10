{ lib
, buildPythonPackage
, fetchPypi
, zope-configuration
, zope-deferredimport
, zope-deprecation
, zope_event
, zope-hookable
, zope-i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-component";
  version = "6.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "zope.component";
    inherit version;
    hash = "sha256-mgoEcq0gG5S0/mdBzprCwwuLsixRYHe/A2kt7E37aQY=";
  };

  propagatedBuildInputs = [
    zope-configuration
    zope-deferredimport
    zope-deprecation
    zope_event
    zope-hookable
    zope-i18nmessageid
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
