{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
  pytest,
  ruff,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "suntime";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SatAgro";
    repo = "suntime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1YQyW6y1HIOmhEnsv+4svJPdfX6FRGMVjuudD5BdgOY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dateutil
  ];

  optional-dependencies = {
    dev = [
      pytest
      ruff
    ];
  };

  pythonImportsCheck = [
    "suntime"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple sunset and sunrise time calculation python library";
    homepage = "https://github.com/SatAgro/suntime";
    changelog = "https://github.com/SatAgro/suntime/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jfly ];
  };
})
