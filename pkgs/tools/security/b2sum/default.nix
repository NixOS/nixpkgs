{ lib, stdenv, fetchFromGitHub, openmp ? null }:

with lib;

stdenv.mkDerivation {
  pname = "b2sum";
  version = "unstable-2018-06-11";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "BLAKE2";
    rev = "320c325437539ae91091ce62efec1913cd8093c2";
    sha256 = "E60M9oP/Sdfg/L3ZxUcDtUXhFz9oP72IybdtVUJh9Sk=";
  };

  # Use the generic C implementation rather than the SSE optimised version on non-x86 platforms
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace makefile \
      --replace "#FILES=b2sum.c ../ref/" "FILES=b2sum.c ../ref/" \
      --replace "FILES=b2sum.c ../sse/" "#FILES=b2sum.c ../sse/"
  '';

  sourceRoot = "source/b2sum";

  buildInputs = [ openmp ];

  buildFlags = [ (optional (openmp == null) "NO_OPENMP=1") ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "The b2sum utility is similar to the md5sum or shasum utilities but for BLAKE2";
    homepage = "https://blake2.net";
    license = with licenses; [ asl20 cc0 openssl ];
    maintainers = with maintainers; [ kirelagin ];
    platforms = platforms.unix;
  };
}
