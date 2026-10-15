{
  lib,
  buildPythonPackage,
  fetchPypi,
  trezor,
  libagent,
  ecdsa,
  ed25519,
  mnemonic,
  keepkey,
  semver,
  setuptools,
  wheel,
  pinentry,
}:

buildPythonPackage rec {
  pname = "trezor-agent";
  version = "0.12.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "trezor_agent";
    inherit version;
    hash = "sha256-4IylpUvXZYAXFkyFGNbN9iPTsHff3M/RL2Eq9f7wWFU=";
  };

  propagatedBuildInputs = [
    setuptools
    trezor
    libagent
    ecdsa
    ed25519
    mnemonic
    keepkey
    semver
    wheel
    pinentry
  ];

  # relax dependency constraint
  postPatch = ''
    substituteInPlace setup.py \
      --replace "trezor[hidapi]>=0.12.0,<0.13" "trezor[hidapi]>=0.12.0,<0.14"
  '';

  doCheck = false;
  pythonImportsCheck = [ "libagent" ];

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
}
