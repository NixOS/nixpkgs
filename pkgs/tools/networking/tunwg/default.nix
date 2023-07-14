{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tunwg";
  version = "23.06.14+dbfe3aa";

  src = fetchFromGitHub {
    owner = "ntnj";
    repo = "tunwg";
    rev = "v${version}";
    hash = "sha256-w7rx2Q0VXQBETmHROcVWzh0TIEjiITpI5CR9jvtXF7E=";
  };

  vendorHash = "sha256-3vDcCOrhYTHvr8ck0WxZPRUQNsKtEVyUKTD5Epbno6I=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Secure private tunnel to your local servers";
    homepage = "https://github.com/ntnj/tunwg";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
