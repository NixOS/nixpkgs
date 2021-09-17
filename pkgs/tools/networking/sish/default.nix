{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tljJp6Yoc19kkG7F3g1XhSDK2Y/D/2oRHiDkkOP3nn0=";
  };

  vendorSha256 = "sha256-AHCa6ErxXzDPUFuq4ATD08e2Wz0tNibV2lLXoD7Sygk=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
