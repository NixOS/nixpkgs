{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  bzip2,
  lzfse,
  xz,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "undmg";
  version = "1.1.0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "0d92602b694f810fa4b137d87c743f345b303a14";
    hash = "sha256-eLxI3enf8EAgQePXvWxw8kOMr7KP2Q1Rsxy++v16zQI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    zlib
    bzip2
    lzfse
    xz
  ];

  setupHook = ./setup-hook.sh;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Extract a DMG file";
    homepage = "https://github.com/matthewbauer/undmg";
    license = lib.licenses.gpl3;
    mainProgram = "undmg";
    maintainers = with lib.maintainers; [
      matthewbauer
      lnl7
    ];
    platforms = lib.platforms.all;
  };
}
