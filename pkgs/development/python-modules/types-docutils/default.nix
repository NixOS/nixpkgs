{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-docutils";
  version = "0.23.0.20260923";
  pyproject = true;

  src = fetchPypi {
    pname = "types_docutils";
    inherit (finalAttrs) version;
    hash = "sha256-SG2QVOqEQQzCAaMMFXWQd6XzIjQkfPwIqnKQ/yUJ93A=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "'docutils-stubs' = [" "'*' = [" \
      --replace-fail "setuptools>=82.0.1" "setuptools"
  '';

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "docutils-stubs" ];

  meta = {
    description = "Typing stubs for docutils";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
