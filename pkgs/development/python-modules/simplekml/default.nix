{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "simplekml";
  version = "1.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zaaHvidUOV/KtmTpCOv1ifrNQehDbSM9K+N6ae+xxTY=";
  };

  # no tests are defined in 1.3.5
  doCheck = false;
  pythonImportsCheck = [ "simplekml" ];

  meta = {
    description = "Python package to generate KML";
    homepage = "https://simplekml.readthedocs.io/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
})
