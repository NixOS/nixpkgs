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
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c1ef62903534d8b01260dbd6304780e278bc83e0bc21f6a83beee76e48e1580";
  };

  propagatedBuildInputs = [ trezor libagent ecdsa ed25519 mnemonic keepkey semver ];

  meta = with stdenv.lib; {
    description = "Using Trezor as hardware SSH agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };

}
