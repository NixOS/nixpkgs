{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sev-snp-measure";
  version = "0.0.12";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "sev-snp-measure";
    tag = "v${version}";
    hash = "sha256-UcXU6rNjcRN1T+iWUNrqeJCkSa02WU1/pBwLqHVPRyw=";
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
    changelog = "https://github.com/virtee/sev-snp-measure/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ msanft ];
    mainProgram = "sev-snp-measure";
  };
}
