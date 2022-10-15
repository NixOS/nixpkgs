{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tDs0OrMeWLhBUnngJRBmAauwMA/zdMC4ED7xcCED4Zs=";
  };

  vendorSha256 = "sha256-Wv0V1/BbO8cP9Qj1TBCDpPTpbv3xzT8eCLPBhCPxRKo=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
