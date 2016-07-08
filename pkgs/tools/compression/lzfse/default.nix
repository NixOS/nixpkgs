{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lzfse-${version}";
  version = "2016-06-21";

  src = fetchFromGitHub {
    owner = "lzfse";
    repo = "lzfse";
    rev = "45912281e3945a09c6ebfa8c6629f6906a99fc29";
    sha256 = "1wbh3x874fjn548g1hw4bm7lkk60vlvy8ph0wsjkzcx8873hwj7h";
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
