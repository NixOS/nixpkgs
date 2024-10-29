{ lib, stdenv, fetchFromGitHub, cmake, gperf, openssl, zlib }:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "7.10";

  src = fetchFromGitHub {
    repo = "telegram-bot-api";
    owner = "tdlib";
    rev = "a186a9ae823d91678ace87ef5b920688c555f5b5";
    hash = "sha256-1oGDR9WLWC/0QyAmTkMWkbkD+49/gU/nWBZq0mMOl8g=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake gperf ];
  buildInputs = [ openssl zlib ];

  meta = with lib; {
    description = "Telegram Bot API server";
    homepage = "https://github.com/tdlib/telegram-bot-api";
    license = licenses.boost;
    maintainers = with maintainers; [ Anillc Forden ];
    platforms = platforms.all;
    mainProgram = "telegram-bot-api";
  };
}
