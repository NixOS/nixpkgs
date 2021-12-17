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

  sourceRoot = "source/b2sum";

  buildInputs = [ openmp ];

  buildFlags = [ (optional (openmp == null) "NO_OPENMP=1") ];
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
