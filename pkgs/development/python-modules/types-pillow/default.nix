{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-pillow";
  version = "10.2.0.20240822";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "types-Pillow";
    hash = "sha256-VZ+1Ki75kcMm5KDSCsyzu2Onuo1A60k+DssDELpS8NM=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "PIL-stubs" ];

  meta = {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arjan-s ];
  };
})
