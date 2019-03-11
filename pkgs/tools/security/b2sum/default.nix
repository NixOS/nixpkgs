{ stdenv, fetchzip, openmp ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "b2sum-${version}";
  version = "unstable-2018-06-11";

  src = fetchzip {
    url = "https://github.com/BLAKE2/BLAKE2/archive/320c325437539ae91091ce62efec1913cd8093c2.tar.gz";
    sha256 = "0agmc515avdpr64bsgv87wby2idm0d3wbndxzkhdfjgzhgv0rb8k";
  };

  sourceRoot = "source/b2sum";

  buildInputs = [ openmp ];

  buildFlags = [ (optional (isNull openmp) "NO_OPENMP=1") ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "The b2sum utility is similar to the md5sum or shasum utilities but for BLAKE2";
    homepage = "https://blake2.net";
    license = with licenses; [ asl20 cc0 openssl ];
    maintainers = with maintainers; [ kirelagin ];
    # "This code requires at least SSE2."
    platforms = with platforms; [ "x86_64-linux" "i686-linux" ] ++ darwin;
  };
}
