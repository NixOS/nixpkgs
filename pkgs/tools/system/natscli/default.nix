{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.32";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/bK7eQaH5VpYm0lfL43DtVxEeoo4z0Ns1ykuA0osPAs=";
  };

  vendorSha256 = "sha256-qg3fmFBHeKujNQr7WFhkdvMQeR/PCBzqTHHeNsCrrMc=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
