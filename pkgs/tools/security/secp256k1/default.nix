{ stdenv, fetchFromGitHub, autoconf, automake, libtool, ... }:

stdenv.mkDerivation rec {
  name = "secp256k1-${version}";

  # I can't find any version numbers, so we're just using the date
  # of the last commit.
  version = "2016-05-30";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "b3be8521e694eaf45dd29baea035055183c42fe2";
    sha256 = "1pgsy72w87yxbiqn96hnm8alsfx3rj7d9jlzdsypyf6i1rf6w4bq";
  };

  buildInputs = [ autoconf automake libtool ];

  configureFlags = [ "--enable-module-recovery" ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
      Optimized C library for EC operations on curve secp256k1.
      Part of Bitcoin Core. This library is a work in progress
      and is being used to research best practices. Use at your
      own risk.
    '';
    homepage = https://github.com/bitcoin-core/secp256k1;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ chris-martin ];
    platforms = with platforms; unix;
  };
}
