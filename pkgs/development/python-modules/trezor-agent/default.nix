{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  trezor,
  libagent,
  keyrings-alt,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "trezor-agent";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "trezor-agent";
    tag = "trezor/${finalAttrs.version}";
    hash = "sha256-hoaMsdD0LRLF5F33ECYnBRxzmtydHxT1UOkVna1hLYA=";
  };

  sourceRoot = "${finalAttrs.src.name}/agents/trezor";

  build-system = [ setuptools ];

  dependencies = [
    libagent
    trezor
    keyrings-alt
  ];

  doCheck = false;
  pythonImportsCheck = [ "trezor_agent" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=trezor/(.*)" ];
  };

  meta = {
    description = "Using Trezor as hardware SSH/GPG/age agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      hkjn
      np
      mmahut
    ];
  };
})
