{ lib, stdenv, fetchFromGitHub, openmp ? null }:

stdenv.mkDerivation (finalAttrs: {
  pname = "b2sum";
  version = "20190724";

  src = fetchFromGitHub {
    owner = "BLAKE2";
    repo = "BLAKE2";
    rev = finalAttrs.version;
    sha256 = "sha256-6BVl3Rh+CRPQq3QxcUlk5ArvjIj/IcPCA2/Ok0Zu7UI=";
  };

  # Use the generic C implementation rather than the SSE optimised version on non-x86 platforms
  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace makefile \
      --replace "#FILES=b2sum.c ../ref/" "FILES=b2sum.c ../ref/" \
      --replace "FILES=b2sum.c ../sse/" "#FILES=b2sum.c ../sse/"
  '';

  sourceRoot = "source/b2sum";

  buildInputs = [ openmp ];

  buildFlags = [ (lib.optional (openmp == null) "NO_OPENMP=1") ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "The b2sum utility is similar to the md5sum or shasum utilities but for BLAKE2";
    homepage = "https://blake2.net";
    license = with licenses; [ asl20 cc0 openssl ];
    maintainers = with maintainers; [ kirelagin ];
    platforms = platforms.unix;
  };
})
