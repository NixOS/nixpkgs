{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sing-box";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CNy+C5E5iAZHZ7PsS0Hj43irCuCvy/bes3kovvH81/o=";
  };

  vendorHash = "sha256-fUHfvqzbu2P7N413dDuV41myhReNSYvgF+Cc6SgG6y4=";

  tags = [
    "with_quic"
    "with_grpc"
    "with_wireguard"
    "with_shadowsocksr"
    "with_ech"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  meta = with lib;{
    homepage = "https://sing-box.sagernet.org";
    description = "The universal proxy platform";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
