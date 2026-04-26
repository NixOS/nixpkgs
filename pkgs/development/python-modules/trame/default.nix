{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  pyyaml,
  wslink,
  trame-common,
  trame-server,
  trame-client,
}:
buildPythonPackage (finalAttrs: {
  name = "trame";
  version = "3.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U58Tq4/NVcFCZ2vTjilbabnbQhlEf2QS/e/7Zy5l5YU=";
  };

  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  propagatedBuildInputs = [
    pyyaml
    wslink
    trame-common
    trame-server
    trame-client
  ];

  pythonImportsCheck = [
    "trame.app"
    "trame.assets"
    "trame.env"
    "trame.modules"
    "trame.tools"
    "trame.ui"
    "trame.utils"
    "trame.widgets"
  ];

  meta = {
    description = "Trame lets you weave various components and technologies into a Web Application solely written in Python";
    homepage = "https://github.com/kitware/trame";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.asl20;
  };
})
