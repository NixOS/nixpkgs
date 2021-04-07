{ lib
, buildPythonPackage
, fetchPypi
, trezor
, libagent
, ecdsa
, ed25519
, mnemonic
, keepkey
, semver
, setuptools
, wheel
, pinentry
}:

buildPythonPackage rec {
  pname = "trezor_agent";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "139d917d6495bf290bcc21da457f84ccd2e74c78b4d59a649e0cdde4288cd20c";
  };

  propagatedBuildInputs = [ setuptools trezor libagent ecdsa ed25519 mnemonic keepkey semver wheel pinentry ];

  doCheck = false;
  pythonImportsCheck = [ "libagent" ];

  meta = with lib; {
    description = "Using Trezor as hardware SSH agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hkjn np mmahut ];
  };

}
