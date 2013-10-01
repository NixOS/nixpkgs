{stdenv, fetchurl, autoconf, automake, trousers, openssl}:

stdenv.mkDerivation {
  name = "tpm-quote-tools-1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/tpmquotetools/1.0.2/tpm-quote-tools-1.0.2.tar.gz";
    sha256 = "17bf9d1hiiaybx6rgl0sqcb0prjz6d2mv8fwp4bj1c0rsfw5dbk8";
  };

  buildInputs = [ trousers openssl ];
}
