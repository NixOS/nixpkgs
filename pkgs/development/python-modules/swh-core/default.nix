{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pythonRelaxDepsHook,
  click,
  deprecated,
  python-magic,
  pyyaml,
  requests,
  sentry-sdk,
  tenacity,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "swh-core";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-core";
    rev = "v${version}";
    hash = "sha256-Fx4GgGXDRskoW+t5jT9ZHhQJ2jbFmwfGvtqy/8Hxtas=";
  };

  build-system = [
    setuptools
    setuptools-scm
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    # sentry-sdk>=2 not satisfied by version 1.45.0
    "sentry-sdk"
  ];

  dependencies = [
    click
    deprecated
    python-magic
    pyyaml
    requests
    sentry-sdk
    tenacity
  ];

  pythonImportsCheck = [ "swh.core" ];

  meta = {
    description = "Low-level utilities and helpers used by almost all other modules in the stack";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-core";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
