{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "snappy-manifolds";
  version = "1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_manifolds";
    tag = "${finalAttrs.version}_as_released";
    hash = "sha256-e+BoPvg0cuEqLq2f9ZPgqFMEYw7eeSEDkY42+l+kDCk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "snappy_manifolds" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "(.*)_as_released"
    ];
  };

  meta = {
    description = "Database of snappy manifolds";
    changelog = "https://github.com/3-manifolds/snappy_manifolds/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
})
