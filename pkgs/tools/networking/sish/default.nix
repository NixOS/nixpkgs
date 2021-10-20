{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v/7DhakTVlcbnhujZOoVx5mpeyMwVI4CfYV12QqR7I4=";
  };

  vendorSha256 = "sha256-eMqHPxewQ9mvBpcBb+13HmaLDabCGt6C+qfbgaW8/YE=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
