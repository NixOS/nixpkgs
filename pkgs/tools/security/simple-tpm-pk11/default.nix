{ stdenv, fetchFromGitHub, trousers, openssl, opencryptoki, autoreconfHook, libtool }:

stdenv.mkDerivation rec {
  name = "simple-tpm-pk11-${version}";
  version = "0.06";

  src = fetchFromGitHub {
    owner = "ThomasHabets";
    repo = "simple-tpm-pk11";
    rev = version;
    sha256 = "0vpbaklr4r1a2am0pqcm6m41ph22mkcrq33y8ab5h8qkhkvhd6a6";
  };

  nativeBuildInputs = [ autoreconfHook libtool ];
  buildInputs = [ trousers openssl opencryptoki ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Simple PKCS11 provider for TPM chips";
    longDescription = ''
      A simple library for using the TPM chip to secure SSH keys.
    '';
    homepage    = https://github.com/ThomasHabets/simple-tpm-pk11;
    license     = licenses.asl20;
    maintainers = with maintainers; [ tstrobel ];
    platforms   = platforms.unix;
  };
}
