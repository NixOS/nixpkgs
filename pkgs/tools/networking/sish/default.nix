{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vsW0zQczsYTTlvYkyvYMwYaIOu6JnXH3ZOwUgdeu+u0=";
  };

  vendorSha256 = "sha256-GoiwpYELleD5tltQgRPGQU725h/uHe8tXqH4tIY//uE=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
