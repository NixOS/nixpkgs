{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gperf,
  openssl,
  zlib,
}:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "7.3";

  src = fetchFromGitHub {
    repo = "telegram-bot-api";
    owner = "tdlib";
    rev = "5951bfbab8b1274437c613c1c48d91be2a050371";
    hash = "sha256-5aNZqP4K+zP7q1+yllr6fysEcewhh/V9Vl6GXQolanI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gperf
  ];
  buildInputs = [
    openssl
    zlib
  ];

  meta = with lib; {
    description = "Telegram Bot API server";
    homepage = "https://github.com/tdlib/telegram-bot-api";
    license = licenses.boost;
    maintainers = with maintainers; [
      Anillc
      Forden
    ];
    platforms = platforms.all;
    mainProgram = "telegram-bot-api";
  };
}
