{ stdenv
, buildPythonPackage
, fetchPypi
, trezor
, libagent
, ecdsa
, ed25519
, mnemonic
, keepkey
, semver
}:

buildPythonPackage rec{
  pname = "trezor_agent";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i5cdamlf3c0ym600pjklij74p8ifj9cv7xrpnrfl1b8nkadswbz";
  };

  propagatedBuildInputs = [ trezor libagent ecdsa ed25519 mnemonic keepkey semver ];

  meta = with stdenv.lib; {
    description = "Using Trezor as hardware SSH agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };

}
