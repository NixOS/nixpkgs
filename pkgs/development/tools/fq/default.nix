{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-9ABlfA7osM1bYMwNy/pQyb32uJbwZry3s3iGHBXiQHQ=";
  };

  vendorSha256 = "sha256-GDhaeR26MXWR23yVy4kjo/mIUR3vezEs8twjoRgzbwU=";

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
