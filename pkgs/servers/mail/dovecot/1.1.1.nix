{stdenv, fetchurl
  , openssl
  , pam
}:

let 
  version = "1.1.1"; 
in

stdenv.mkDerivation {
  name = "dovecot-${version}";

  buildInputs = [openssl pam];

  src = fetchurl {
    url = "http://dovecot.org/releases/1.1/dovecot-${version}.tar.gz";
    sha256 = "0plzrzz07k0cylk9323gs9fzlv176y6nd6am660b6dch4p884sck";
  };
  
}
