{ stdenv, fetchurl, openmp ? null }:

stdenv.mkDerivation rec {
  version = "unstable-2018-06-11";
  rev = "320c325437539ae91091ce62efec1913cd8093c2";
  name = "b2sum-${version}";

  src = fetchurl {
    url = "https://github.com/BLAKE2/BLAKE2/archive/${rev}.tar.gz";
    sha256 = "19f07dwli9ymlc87ikn84j4h5fv57afwj9ni7s0jkaym5l0q6nqw";
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
