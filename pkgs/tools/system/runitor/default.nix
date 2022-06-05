{ lib, buildGoModule, fetchFromGitHub, fetchpatch, testers, runitor }:

buildGoModule rec {
  pname = "runitor";
  version = "0.10.0";
  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "bdd";
    repo = "runitor";
    rev = "v${version}";
    sha256 = "sha256-96WKMeRkkG6en9JXaZjjnqeZOcLSII3knx8cdjTBAKw=";
  };

  ldflags = [
    "-s" "-X main.Version=v${version}"
  ];

  patches = [
    (fetchpatch {
      name = "backport_TestPostRetries-timeout-fix.patch";
      url = "https://github.com/bdd/runitor/commit/418142585a8387224825637cca3fe275d3c3d147.patch";
      sha256 = "sha256-cl+KYoiHm2ioFuJVKokZkglIzL/NaEd5JNUuj4g8MUg=";
    })
  ];

  passthru.tests.version = testers.testVersion {
    package = runitor;
    command = "runitor -version";
    version = "v${version}";
  };

  # Unit tests require binding to local addresses for listening sockets.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://bdd.fi/x/runitor";
    description = "A command runner with healthchecks.io integration";
    longDescription = ''
      Runitor runs the supplied command, captures its output, and based on its exit
      code reports successful or failed execution to https://healthchecks.io or your
      private instance.

      Healthchecks.io is a web service for monitoring periodic tasks. It's like a
      dead man's switch for your cron jobs. You get alerted if they don't run on time
      or terminate with a failure.
    '';
    license = licenses.bsd0;
    maintainers = with maintainers; [ bdd ];
  };
}
