{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-deprecated";
  version = "1.3.1.20260728";
  pyproject = true;

  src = fetchPypi {
    pname = "types_deprecated";
    inherit (finalAttrs) version;
    hash = "sha256-yrg2/c9rV9Pid+YtnXbYpMVWomOf0OkMtVX6DoMA0WQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=82.0.1" "setuptools" \
      --replace-fail "'deprecated-stubs' =" "'*' ="
  '';

  build-system = [ setuptools ];

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "deprecated-stubs" ];

  meta = {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
