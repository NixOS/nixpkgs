{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.24";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = version;
    sha256 = "11rpgvcnd2m4g0jnv6g0zdvnhs37jwn1c4hc86xgnk2vipvy0nw2";
  };

  vendorSha256 = "0nrgbwc10pp7adj0w1jjj6677y2dpqq969ij7i0pmvr08ni95sxw";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
