{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lzfse-${version}";
  version = "2017-03-08";

  src = fetchFromGitHub {
    owner = "lzfse";
    repo = "lzfse";
    rev = "88e2d27";
    sha256 = "1mfh6y6vpvxsdwmqmfbkqkwvxc0pz2dqqc72c6fk9sbsrxxaghd5";
  };

  makeFlags = [ "INSTALL_PREFIX=$(out)" ];

  enableParallelBuilding = false; #bug

  meta = with stdenv.lib; {
    homepage = https://github.com/lzfse/lzfse;
    description = "a reference C implementation of the LZFSE compressor";
    longDescription = ''
      This is a reference C implementation of the LZFSE compressor introduced in the Compression library with OS X 10.11 and iOS 9.
      LZFSE is a Lempel-Ziv style data compression algorithm using Finite State Entropy coding.
      It targets similar compression rates at higher compression and decompression speed compared to deflate using zlib.
    '';
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
