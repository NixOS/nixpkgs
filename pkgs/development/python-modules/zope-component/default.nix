{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, zope-configuration
, zope-deferredimport
, zope-deprecation
, zope-event
, zope-hookable
, zope-i18nmessageid
, zope_interface
}:

buildPythonPackage rec {
  pname = "zope-component";
  version = "6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.component";
    inherit version;
    hash = "sha256-mgoEcq0gG5S0/mdBzprCwwuLsixRYHe/A2kt7E37aQY=";
  };

  propagatedBuildInputs = [
    zope-configuration
    zope-deferredimport
    zope-deprecation
    zope-event
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
    description = "Zope Component Architecture";
    homepage = "https://github.com/zopefoundation/zope.component";
    changelog = "https://github.com/zopefoundation/zope.component/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
