{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-7q08fQUFy4qX3VqUHuvOZuVQdFeoeo5+7HUQ4WWMWYw=";
  };

  vendorHash = "sha256-7TGdbGVx7YTuYBmHYK0dqccxSTkLzUlBk21EREv9XBA=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
