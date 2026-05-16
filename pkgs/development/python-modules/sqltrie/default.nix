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
  version = "0.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "sqltrie";
    tag = version;
    hash = "sha256-D1vYXyh/i0wy7sttW117vsMbUlQJ/mq7rlxLMJWoki0=";
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
    homepage = "https://github.com/iterative/sqltrie";
    changelog = "https://github.com/iterative/sqltrie/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
