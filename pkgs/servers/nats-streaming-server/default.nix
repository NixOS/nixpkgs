{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

with lib;

buildGoModule rec {
  pname = "nats-streaming-server";
  version = "0.25.6";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "nats-io";
    repo = pname;
    sha256 = "sha256-i5fNxeJQXiyy+9NOGT1X68u9Pztxvnnba64rxIgjbZc=";
  };

  vendorHash = "sha256-r6RDHGAt83sKyMHvG3927rZroWdnTQFb8zTrmlc0W5U=";

  # tests fail and ask to `go install`
  doCheck = false;

  meta = {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
    mainProgram = "nats-streaming-server";
  };
}
