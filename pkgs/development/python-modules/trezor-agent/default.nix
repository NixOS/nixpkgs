{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  trezor,
  libagent,
  setuptools,
  pinentry,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "trezor-agent";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "romanz";
    repo = "trezor-agent";
    tag = "trezor/${finalAttrs.version}";
    hash = "sha256-hoaMsdD0LRLF5F33ECYnBRxzmtydHxT1UOkVna1hLYA=";
  };

  sourceRoot = "${finalAttrs.src.name}/agents/trezor";

  propagatedBuildInputs = [
    setuptools
    trezor
    libagent
    pinentry
  ];

  doCheck = false;
  pythonImportsCheck = [ "libagent" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=trezor/(.*)" ];
  };

  meta = {
    description = "Using Trezor as hardware SSH agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      hkjn
      np
      mmahut
    ];
  };
})
