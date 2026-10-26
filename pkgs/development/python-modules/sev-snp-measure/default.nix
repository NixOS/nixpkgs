{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sev-snp-measure";
  version = "0.0.13";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "sev-snp-measure";
    tag = "v${finalAttrs.version}";
    hash = "sha256-euAmKIdLJiA+iRlsPJCxPuquE9eznwd937LVWO4DKpc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [ "cryptography" ];

  propagatedBuildInputs = [ cryptography ];

  pythonImportsCheck = [ "sevsnpmeasure" ];

  meta = {
    description = "Calculate AMD SEV/SEV-ES/SEV-SNP measurement for confidential computing";
    homepage = "https://github.com/virtee/sev-snp-measure";
    changelog = "https://github.com/virtee/sev-snp-measure/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ msanft ];
    mainProgram = "sev-snp-measure";
  };
})
