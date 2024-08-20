{
  lib,
  stdenv,
  fetchFromGitHub,
}:
let
  # This repository has numbered versions, but not Git tags.
  rev = "b7d180fe73636740f694ec60c1ffab52b06e7150";
in
stdenv.mkDerivation {
  pname = "agrep";
  version = "3.41.5-unstable-2022-03-23";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Wikinaut";
    repo = "agrep";
    hash = "sha256-2J4bw5BVZgTEcIn9IuD5Q8/L+8tldDbToDefuxDf85g=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-std=c89";

  installPhase = ''
    runHook preInstall

    install -Dm 555 agrep -t "$out/bin"
    install -Dm 444 docs/* -t "$out/doc"

    runHook postInstall
  '';

  meta = {
    description = "Approximate grep for fast fuzzy string searching";
    mainProgram = "agrep";
    homepage = "https://www.tgries.de/agrep/";
    maintainers = with lib.maintainers; [ momeemt ];
    changelog = "https://github.com/Wikinaut/agrep/blob/${rev}/CHANGES";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
}
