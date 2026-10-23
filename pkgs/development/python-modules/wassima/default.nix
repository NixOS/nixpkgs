{
  buildPythonPackage,
  cacert,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wassima";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jawah";
    repo = "wassima";
    tag = finalAttrs.version;
    hash = "sha256-cAJLjcFSabSQi7GQTFjaZNxq4BCXCSiCJIFHGZ/Lsyo=";
  };

  postPatch = ''
    # override the bundled list of trusted CA with the system store
    sed -i '/^CCADB_BUNDLE: str = """$/,/^"""$/d' src/wassima/_os/_embed.py
    substituteInPlace src/wassima/_os/_embed.py \
      --replace-fail "from ..utils import PEM_cert_to_DER_cert" $'from pathlib import Path\n\nfrom ..utils import PEM_cert_to_DER_cert' \
      --replace-fail "CCADB_BUNDLE.split(boundary)" 'Path("${cacert}/etc/ssl/certs/ca-bundle.crt").read_text(encoding="utf-8").split(boundary)'
  '';

  build-system = [ hatchling ];

  pythonImportsCheck = [ "wassima" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests connect to the internet
  doCheck = false;

  meta = {
    changelog = "https://github.com/jawah/wassima/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Access your OS root certificates with utmost ease";
    homepage = "https://github.com/jawah/wassima";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
