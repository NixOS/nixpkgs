{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-paramiko";
  version = "4.0.0.20250822";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_paramiko";
    inherit (finalAttrs) version;
    hash = "sha256-G1awy9Puw9L9EjyesnBOYSt3fhWhdwWoBCeeplJeDFM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
  ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "paramiko-stubs" ];

  meta = {
    description = "Typing stubs for paramiko";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
