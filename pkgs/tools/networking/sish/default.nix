{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0rUQRul6es+m8JFGXChrygwU5fBi6RiYhoD1dQHpG3s=";
  };

  vendorSha256 = "sha256-GoiwpYELleD5tltQgRPGQU725h/uHe8tXqH4tIY//uE=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
