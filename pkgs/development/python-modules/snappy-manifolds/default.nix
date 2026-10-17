{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "snappy-manifolds";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "snappy_manifolds";
    tag = "${version}_as_released";
    hash = "sha256-CDz95eHnnJQJ2dvTsOQ1V31QgGb5BgIH0uGc3dj2cAU=";
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
    changelog = "https://github.com/3-manifolds/snappy_manifolds/releases/tag/${src.tag}";
    homepage = "https://snappy.computop.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
