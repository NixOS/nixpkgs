{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pygtrie,
  orjson,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqltrie";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "sqltrie";
    tag = finalAttrs.version;
    hash = "sha256-sBu82SDOBqlQLONYgQ4eCw6MVFsLIs5/LfevP4cUDTo=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    orjson
    pygtrie
  ];

  # nox is not available at the moment
  doCheck = false;

  pythonImportsCheck = [ "sqltrie" ];

  meta = {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/sqltrie";
    changelog = "https://github.com/iterative/sqltrie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
