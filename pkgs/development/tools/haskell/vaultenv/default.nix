{ mkDerivation, fetchurl, async, base, bytestring, http-conduit, lens
, lens-aeson, optparse-applicative, retry, stdenv, text, unix
, unordered-containers, utf8-string
}:

mkDerivation rec {
  pname = "vaultenv";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/channable/vaultenv/archive/v${version}.tar.gz";
    sha256 = "0hdcxq88cf3ygnikkppyg3fcf7xmwm9zif7274j3n34p9vd8xci3";
  };

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async base bytestring http-conduit lens lens-aeson
    optparse-applicative retry text unix unordered-containers
    utf8-string
  ];
  homepage = "https://github.com/channable/vaultenv";
  description = "Runs processes with secrets from HashiCorp Vault";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ lnl7 ];
}
