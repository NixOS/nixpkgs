
args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.isc.org/isc/bind9/9.5.0/bind-9.5.0.tar.gz;
    sha256 = "0qfxipj6v9hs9plx388ysnyvpkiamgxpsq8xqzw9hliag4nc1d7v";
  };

  buildInputs = [openssl libtool];
  configureFlags = ["--with-libtool" "--with-openssl=${openssl}"];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "bind-9.5.0";
  meta = {
    description = "ISC BIND: a domain name server";
  };
}
