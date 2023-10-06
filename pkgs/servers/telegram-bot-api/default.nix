{ lib, stdenv, fetchFromGitHub, cmake, gperf, openssl, zlib }:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "5.7";

  src = fetchFromGitHub {
    repo = "telegram-bot-api";
    owner = "tdlib";
    rev = "c57b04c4c8c4e8d8bb6fdd0bd3bfb5b93b9d8f05";
    sha256 = "sha256-WetzX8GBdwQAnnZjek+W4v+QN1aUFdlvs+Jv6n1B+eY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake gperf ];
  buildInputs = [ openssl zlib ];

  meta = with lib; {
    description = "Telegram Bot API server";
    homepage = "https://github.com/tdlib/telegram-bot-api";
    license = licenses.boost;
    maintainers = with maintainers; [ Anillc ];
    platforms = platforms.all;
  };
}
