{ lib, stdenv, fetchFromGitHub, openmp ? null }:

with lib;

stdenv.mkDerivation rec {
  pname = "b2sum";
  version = "20190724";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "BLAKE2";
    rev = "${version}";
    sha256 = "sha256-6BVl3Rh+CRPQq3QxcUlk5ArvjIj/IcPCA2/Ok0Zu7UI=";
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
    platforms = [ "x86_64-linux" "i686-linux" ] ++ platforms.darwin;
  };
}
