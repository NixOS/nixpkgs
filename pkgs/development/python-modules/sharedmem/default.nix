{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "sharedmem";
  version = "0.3.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rainwoodman";
    repo = "sharedmem";
    tag = finalAttrs.version;
    hash = "sha256-sQYSIMLXhChBDKlb8x7kRo1ZKKXEdWSjvxp0SZGKems=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "sharedmem" ];

  meta = {
    homepage = "http://rainwoodman.github.io/sharedmem/";
    description = "Easier parallel programming on shared memory computers";
    maintainers = with lib.maintainers; [ edwtjo ];
    license = lib.licenses.gpl3Only;
  };
})
