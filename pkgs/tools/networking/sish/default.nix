{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gk6hUv6SKZ71iJdeh9fvA45Oj3J1TjPWpvKQT5qj8NU=";
  };

  vendorSha256 = "sha256-FCLhAJxEPskigvlzvm5A+hVQOSWqqZnAxCPe7cawryA=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
