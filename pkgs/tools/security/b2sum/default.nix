{ stdenv, fetchurl, openmp }:

stdenv.mkDerivation rec {
  version = "20160619";
  name = "b2sum-${version}";

  src = fetchurl {
    url = "https://github.com/BLAKE2/BLAKE2/archive/${version}.tar.gz";
    sha256 = "0csnlp6kwlyla5s4r6bsrx2jgcwrm9qzisnvfdhmqsz5r8y87b6b";
  };
  postUnpack = "sourceRoot=$sourceRoot/b2sum";

  buildInputs = [ openmp ];

  makeFlags = stdenv.lib.optional (isNull openmp) "NO_OPENMP=1";
  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "The b2sum utility is similar to the md5sum or shasum utilities but for BLAKE2";
    homepage = "https://blake2.net";
    license = with licenses; [ asl20 cc0 openssl ];
    maintainers = with maintainers; [ kirelagin ];
    platforms = platforms.all;
  };
}
