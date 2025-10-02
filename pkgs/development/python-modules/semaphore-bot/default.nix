{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  attrs,
  anyio,
}:

buildPythonPackage rec {
  pname = "semaphore-bot";
  version = "0.17.0";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-3zb6+HdOB6+YrVRcmIHsokFKUOlFmKCoVNllvM+aOXQ=";
  };

  pythonRelaxDeps = [
    "anyio"
    "attrs"
    "python_dateutil"
  ];

  build-system = [ setuptools ];

  dependencies = [
    anyio
    attrs
    python-dateutil
  ];

  # Upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "semaphore" ];

  meta = with lib; {
    description = "Simple rule-based bot library for Signal Private Messenger";
    homepage = "https://github.com/lwesterhof/semaphore";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ onny ];
  };
}
