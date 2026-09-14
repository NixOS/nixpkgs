{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-colorama";
  version = "0.4.15.20260508";
  pyproject = true;

  src = fetchPypi {
    pname = "types_colorama";
    inherit (finalAttrs) version;
    hash = "sha256-OokWA55XRSvSH1fmdOHyIcqeTzGYk8Xju9N7hFwn2OY=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
