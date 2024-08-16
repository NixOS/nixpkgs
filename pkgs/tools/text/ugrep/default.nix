{ lib
, stdenv
, fetchFromGitHub
, boost
, brotli
, bzip2
, bzip3
, lz4
, pcre2
, testers
, xz
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugrep";
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "ugrep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0T/fX+ZzxfJD3CmoYLWSe3LE6B4HWkCC2bqXNwzUVpk=";
  };

  buildInputs = [
    boost
    brotli
    bzip2
    bzip3
    lz4
    pcre2
    xz
    zlib
    zstd
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    changelog = "https://github.com/Genivia/ugrep/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ numkem mikaelfangel ];
    license = licenses.bsd3;
    platforms = platforms.all;
    mainProgram = "ug";
  };
})
