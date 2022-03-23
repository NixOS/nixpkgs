{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testVersion
}:

buildGoModule rec {
  pname = "fq";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-/9TBnhFGYNOcCsQKUF0uuJEgnF+qRGly/5z1s3sYhqY=";
  };

  vendorSha256 = "sha256-zvtYyNJO4QoTes3vf6CFa3dYMJqkp0PG9pnOk+aO97Y=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
