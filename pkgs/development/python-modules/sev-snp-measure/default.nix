{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sev-snp-measure";
  version = "0.0.11";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "sev-snp-measure";
    rev = "refs/tags/v${version}";
    hash = "sha256-M+d9uIAQvEmEsdhhjlwHbhB2RhlaGjphN4ov2ipzCFY=";
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
    changelog = "https://github.com/virtee/sev-snp-measure/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ msanft ];
    mainProgram = "sev-snp-measure";
  };
}
