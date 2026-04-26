{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  trame-client,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-components";
  version = "2.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-components";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qn3HMVEXPp0H7nqtIbHopT10ZYXf/zB0y++gX+MykOo=";
  };

  pyproject = true;
  build-system = [
    setuptools
  ];
  propagatedBuildInputs = [
    trame-client
  ];

  pythonImportsCheck = [
    "trame_components.module"
    "trame_components.widgets"
  ];

  meta = {
    description = "Core widgets for trame";
    homepage = "https://github.com/kitware/trame-components";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.asl20;
  };
})
