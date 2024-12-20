{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-event,
}:

buildPythonPackage rec {
  pname = "zope.interface";
  version = "6.4.post2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HCB+b239V0mib1pf2WZgLWuCTsANLfhKfpqSTokzZU4=";
  };

  build-system = [ setuptools ];

  dependencies = [ zope-event ];

  doCheck = false; # Circular deps.

  meta = with lib; {
    changelog = "https://github.com/zopefoundation/zope.interface/blob/${version}/CHANGES.rst";
    description = "Zope.Interface";
    homepage = "https://github.com/zopefoundation/zope.interface";
    license = licenses.zpl20;
    maintainers = [ ];
  };
}
