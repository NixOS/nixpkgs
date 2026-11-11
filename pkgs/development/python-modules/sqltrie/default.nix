{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pygtrie,
  orjson,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "sqltrie";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "sqltrie";
    tag = version;
    hash = "sha256-sBu82SDOBqlQLONYgQ4eCw6MVFsLIs5/LfevP4cUDTo=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    attrs
    orjson
    pygtrie
  ];

  # nox is not available at the moment
  doCheck = false;

  pythonImportsCheck = [ "sqltrie" ];

  meta = {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/treeverse/sqltrie";
    changelog = "https://github.com/treeverse/sqltrie/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
