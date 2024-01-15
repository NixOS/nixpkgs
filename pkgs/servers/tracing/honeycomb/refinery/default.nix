{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "honeycomb-refinery";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "refinery";
    rev = "v${version}";
    hash = "sha256-SU9JbyUuBMqPw4XcoF5s8CgBn7+V/rHBAwpXJk373jg=";
  };

  NO_REDIS_TEST = true;

  patches = [
    # Allows turning off the one test requiring a Redis service during build.
    # We could in principle implement that, but it's significant work to little
    # payoff.
    ./0001-add-NO_REDIS_TEST-env-var-that-disables-Redis-requir.patch
  ];

  excludedPackages = [ "cmd/test_redimem" ];

  ldflags = [ "-s" "-w" "-X main.BuildID=${version}" ];

  vendorHash = "sha256-0M05JGLdmKivRTN8ZdhAm+JtXTlYAC31wFS82g3NenI=";

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/honeycombio/refinery";
    description = "A tail-sampling proxy for OpenTelemetry";
    license = licenses.asl20;
    maintainers = with maintainers; [ lf- ];
    mainProgram = "refinery";
  };
}
