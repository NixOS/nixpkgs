{ stdenv, fetchgit, trousers, openssl, opencryptoki, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  name = "simple-tpm-pk11-2014-09-25";

  src = fetchgit {
    url = "https://github.com/ThomasHabets/simple-tpm-pk11";
    rev = "f26f10e11344560ff6e1479e6795dc0e5dc49a26";
    sha256 = "0546lhxssngpkrhg5kmrvn4bm1s2kyd20kvhz3rfavfrvr72cs9k";
  };

  buildInputs = [ trousers openssl opencryptoki automake autoconf libtool ];

  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "Simple PKCS11 provider for TPM chips";
    longDescription = ''
      A simple library for using the TPM chip to secure SSH keys.
      '';
    homepage    = https://github.com/ThomasHabets/simple-tpm-pk11;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib; [ maintainers.tstrobel ];
    platforms   = platforms.unix;
  };
}

