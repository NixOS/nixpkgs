{ mkDerivation, fetchzip, async, base, bytestring, hpack, http-conduit
, lens, lens-aeson, optparse-applicative, retry, stdenv, text, unix
, unordered-containers, utf8-string
}:

mkDerivation rec {
  pname = "vaultenv";
  version = "0.5.3";

  src = fetchzip {
    url = "https://github.com/channable/vaultenv/archive/v${version}.tar.gz";
    sha256 = "1kxq2pp8l8xf7xwjyd9cwyi7z192013s6psq5fk8jrkkhrk8z3li";
  };

  buildTools = [ hpack ];
  preConfigure = "hpack .";

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async base bytestring http-conduit lens lens-aeson
    optparse-applicative retry text unix unordered-containers
    utf8-string
  ];
  homepage = https://github.com/channable/vaultenv;
  description = "Runs processes with secrets from HashiCorp Vault";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with stdenv.lib.maintainers; [ lnl7 ];
}
