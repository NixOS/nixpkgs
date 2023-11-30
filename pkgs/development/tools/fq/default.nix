{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testers
}:

buildGoModule rec {
  pname = "fq";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-ohSjQxVbywOcZHwDditqDyQ+EAgzWtLXRc130dpIzzE=";
  };

  vendorHash = "sha256-yfunwj+0fVrWV1RgZtCsdmV4ESKF7VLr12P2nULyqOg=";

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
