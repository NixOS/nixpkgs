{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = version;
    sha256 = "180511x3sciqs0njz80qc1a785m84ks9l338qi3liv7bcd541xcr";
  };

  vendorSha256 = "1j2a6wmyb9akndiwq79jqy5lz84bz2k01xp505j60ynsflim7shq";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
