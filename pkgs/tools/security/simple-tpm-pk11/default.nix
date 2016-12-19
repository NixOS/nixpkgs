{ stdenv, fetchgit, trousers, openssl, opencryptoki, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  name = "simple-tpm-pk11-2016-07-12";

  src = fetchgit {
    url = "https://github.com/ThomasHabets/simple-tpm-pk11";
    rev = "6f1f7a6b96ac82965e977cfecb88d930f1d70243";
    sha256 = "06vf3djp29slh7hrh4hlh3npyl277fy7d77jv9mxa1sk1idjklxc";
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

