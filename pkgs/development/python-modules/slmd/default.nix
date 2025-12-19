{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "slmd";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EAvIiNw9QxwJXXTPPc9RH6K1ZCdXiqUz4siyfsZFrWU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "slmd" ];

  meta = {
    description = "CLI tool to sort lists in Markdown files";
    homepage = "https://github.com/lqez/slmd";
    changelog = "https://github.com/lqez/slmd/blob/main/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
