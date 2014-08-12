{ stdenv, fetchurl, trousers, openssl }:

stdenv.mkDerivation {
  name = "tpm-quote-tools-1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/tpmquotetools/1.0.2/tpm-quote-tools-1.0.2.tar.gz";
    sha256 = "17bf9d1hiiaybx6rgl0sqcb0prjz6d2mv8fwp4bj1c0rsfw5dbk8";
  };

  buildInputs = [ trousers openssl ];

  meta = with stdenv.lib; {
    description = ''The TPM Quote Tools is a collection of programs that provide support
                    for TPM based attestation using the TPM quote mechanism.  The manual
                    page for tpm_quote_tools provides a usage overview.'';
    homepage    = http://tpmquotetools.sourceforge.net/;
    license     = licenses.bsd3;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.linux;
  };
}
