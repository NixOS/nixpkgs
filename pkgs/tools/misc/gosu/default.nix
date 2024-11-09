{ lib, buildGoModule, fetchFromGitHub, testers, gosu }:

buildGoModule rec {
  pname = "gosu";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    hash = "sha256-ziviUXqCpCGECewyZNLDKSjnpmz/3i5DKrIKZlLwl4o=";
  };

  vendorHash = "sha256-fygLYSO0kpMFJd6WQp/uLYkELkyaOPZ9V8BrJcIcMuU=";

  ldflags = [ "-d" "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gosu;
  };

  meta = with lib; {
    description = "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    mainProgram = "gosu";
    homepage = "https://github.com/tianon/gosu";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
