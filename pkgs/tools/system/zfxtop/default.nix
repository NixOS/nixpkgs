{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfxtop";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ssleert";
    repo = "zfxtop";
    rev = version;
    hash = "sha256-auq5NvpI7De9/QBUDPFtXwsAeX/D2RmlVaKe/lrs1MQ=";
  };

  vendorHash = "sha256-VKBRgDu9xVbZrC5fadkdFjd1OETNwaxgraRnA34ETzE=";

  meta = with lib; {
    description = "fetch top for gen Z with X written by bubbletea enjoyer";
    homepage = "https://github.com/ssleert/zfxtop";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wozeparrot ];
  };
}
