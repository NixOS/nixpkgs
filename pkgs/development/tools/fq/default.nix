{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-OAdKt5RgLVoTmccN50TUwUAU7VLiTU9hEnDAKxKBRzI=";
  };

  vendorSha256 = "sha256-Y9wfeAX0jt3KrpRa5kJi8V8WN/hp4jTcPCbvy0RDGRk=";

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
