{ lib
, buildGoModule
, fetchFromGitHub
, testers
, nats-top
}:

buildGoModule rec {
  pname = "nats-top";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zOo+f4NVFvx9deV1QY7mCi6Q0EJRMRwPu12maFDlnCU=";
  };

  vendorHash = "sha256-oPapBYm3gJtPpVP0lmsVijAdjK6M8/kOx/7QIeInOlM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = nats-top;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "top-like tool for monitoring NATS servers";
    homepage = "https://github.com/nats-io/nats-top";
    changelog = "https://github.com/nats-io/nats-top/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats-top";
  };
}
