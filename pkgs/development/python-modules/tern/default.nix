{
  lib,
  buildPythonPackage,
  debian-inspector,
  docker,
  dockerfile-parse,
  fetchPypi,
  setuptools,
  gitpython,
  idna,
  license-expression,
  packageurl-python,
  pbr,
  prettytable,
  pyyaml,
  regex,
  requests,
  stevedore,
}:

buildPythonPackage (finalAttrs: {
  pname = "tern";
  version = "2.12.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "tern";
    inherit (finalAttrs) version;
    hash = "sha256-yMIvFiliEHrbZMqvX3ZAROWcqii5VmB54QEYHGRJocA=";
  };

  build-system = [
    setuptools
    pbr
  ];

  preBuild = ''
    cp requirements.{in,txt}
  '';

  dependencies = [
    pyyaml
    docker
    dockerfile-parse
    license-expression
    requests
    stevedore
    debian-inspector
    regex
    gitpython
    prettytable
    idna
    packageurl-python
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "tern" ];

  meta = {
    description = "Software composition analysis tool and Python library that generates a Software Bill of Materials for container images and Dockerfiles";
    mainProgram = "tern";
    homepage = "https://github.com/tern-tools/tern";
    changelog = "https://github.com/tern-tools/tern/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
