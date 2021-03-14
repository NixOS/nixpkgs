{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-shadowsocks2";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "go-shadowsocks2";
    rev = "v${version}";
    sha256 = "1wzy3ml4ld83iawcl6p313bskzs6zjhz8vlg8kpwgn71cnbv4pvi";
  };

  vendorSha256 = "0iyak8af708h3rdrslndladbcjrix35j3rlhpsb8ljchqp09lksg";

  meta = with lib; {
    description = "Fresh implementation of Shadowsocks in Go";
    homepage = "https://github.com/shadowsocks/go-shadowsocks2/";
    license = licenses.asl20;
    maintainers = with maintainers; [ oxzi ];
  };
}
