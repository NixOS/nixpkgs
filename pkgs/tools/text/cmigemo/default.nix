{ lib, stdenv, fetchFromGitHub
, iconv, nkf, perl, which
, skk-dicts
}:

stdenv.mkDerivation {
  pname = "cmigemo";
  version = "1.3e";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "cmigemo";
    rev = "e0f6145f61e0b7058c3006f344e58571d9fdd83a";
    sha256 = "00a6kdmxp16b8x0p04ws050y39qspd1bqlfq74bkirc55b77a2m1";
  };

  nativeBuildInputs = [ iconv nkf perl which ];

  postUnpack = ''
    cp ${skk-dicts}/share/SKK-JISYO.L source/dict/
  '';

  patches = [ ./no-http-tool-check.patch ];

  makeFlags = [ "INSTALL=install" ];

  buildFlags = [ (if stdenv.isDarwin then "osx-all" else "gcc-all") ];

  installTargets = [ (if stdenv.isDarwin then "osx-install" else "gcc-install") ];

  meta = with lib; {
    description = "A tool that supports Japanese incremental search with Romaji";
    homepage = "https://www.kaoriya.net/software/cmigemo";
    license = licenses.mit;
    maintainers = [ maintainers.cohei ];
    platforms = platforms.all;
  };
}
