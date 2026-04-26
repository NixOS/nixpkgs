{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  name = "trame-common";
  version = "1.1.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "trame-common";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ymDF29WNChxU4fdIGQlIpIL4mM8GgCMRICEZX5jTTyM=";
  };

  pyproject = true;
  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "trame_common.assets"
    "trame_common.decorators"
    "trame_common.exec"
    "trame_common.obj"
    "trame_common.utils"
  ];

  meta = {
    description = "Set of common classes and functions with no dependencies for various trame packages";
    homepage = "https://github.com/kitware/trame-common";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.asl20;
  };
})
