{ buildGoModule, fetchFromGitHub, lib  }:

buildGoModule rec {
  pname   = "nats-streaming-server";
  version = "0.24.6";

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "nats-io";
    repo   = pname;
    sha256 = "sha256-CEDUlMigOK8ZAntqwD6jnqcMhDfgxrrrP53QU6XgI6k=";
  };

  vendorSha256 = "sha256-qaKkYcHOpnQQUWg3jWq99hM9y/7p0Vsy6hQm7HqXEKg=";

  # tests fail and ask to `go install`
  doCheck = false;

  meta = with lib; {
    description = "NATS Streaming System Server";
    license = licenses.asl20;
    maintainers = [ maintainers.swdunlop ];
    homepage = "https://nats.io/";
  };
}
