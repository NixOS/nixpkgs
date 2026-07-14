{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.22.3.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_docutils";
    inherit version;
    hash = "sha256-LEW6Y6msZCRjNTWbaP6cJ2ApJkmcm2fK7DeAdF9qre4=";
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
}
