{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  networkx,
  platformdirs,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "yclade";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "yclade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YtFvSxMwOxgdaAVY5Vfyyz5B2KP0DcEBB09APAO8yuY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    networkx
    platformdirs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yclade" ];

  meta = {
    description = "Python library to determine Y DNA haplogroups from SNP data";
    homepage = "https://github.com/DavidMStraub/yclade";
    changelog = "https://github.com/DavidMStraub/yclade/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
