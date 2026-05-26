{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-fonts";
  version = "2026.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "fonts";
    tag = finalAttrs.version;
    hash = "sha256-JFnLi7ezme3yNo8e0Xjmvf/ejSaeTzzaJD5CMK4I9QM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.9.15,<0.10.0" \
        "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [ "weblate_fonts" ];

  meta = {
    description = "Weblate fonts collection";
    homepage = "https://github.com/WeblateOrg/fonts";
    changelog = "https://github.com/WeblateOrg/fonts/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      cc0
      ofl
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
