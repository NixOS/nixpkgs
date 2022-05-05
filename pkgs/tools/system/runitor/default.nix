{ lib, buildGoModule, fetchFromGitHub, testers, runitor }:

buildGoModule rec {
  pname = "runitor";
  version = "0.9.2";
  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "bdd";
    repo = "runitor";
    rev = "v${version}";
    sha256 = "sha256-LuCxn4j0MlnJjSh3d18YNzNrtbqtMPxgkZttqKUGJd4";
  };

  ldflags = [
    "-s" "-w" "-X main.Version=v${version}"
  ];

  # TODO(cole-h):
  # End-to-end tests requiring localhost networking currently under
  # OfBorg's Linux builders, while passing under Darwin.
  #
  # Ref: https://github.com/NixOS/nixpkgs/pull/170566#issuecomment-1114034891
  #
  # Temporarily disable tests.
  doCheck = false;

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
