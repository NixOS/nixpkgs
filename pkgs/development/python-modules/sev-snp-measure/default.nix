{
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  pythonRelaxDepsHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sev-snp-measure";
  version = "0.0.9";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "sev-snp-measure";
    rev = "v${version}";
    hash = "sha256-efW4DMple26S3Jizc7yAvdPjVivyMJq4fEdkuToamGc=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "cryptography" ];

  propagatedBuildInputs = [ cryptography ];

  postPatch = ''
    # See https://github.com/virtee/sev-snp-measure/pull/46
    sed -i '/types-cryptography/d' setup.cfg requirements.txt
  '';

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
