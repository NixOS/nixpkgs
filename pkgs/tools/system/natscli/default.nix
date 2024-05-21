{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = "natscli";
    rev = "refs/tags/v${version}";
    hash = "sha256-c2bFFbHKjKwkzX2Br1CC2aMh1Tz0NPVWCfPSFbu/XnU=";
  };

  vendorHash = "sha256-ltTQWAS6OG485oj6GEpgQnnuCUunSqUtgq1/OPcjKmQ=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    changelog = "https://github.com/nats-io/natscli/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
