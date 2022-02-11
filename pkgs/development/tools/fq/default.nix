{ lib
, buildGoModule
, fetchFromGitHub
, fq
, testVersion
}:

buildGoModule rec {
  pname = "fq";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-yC2Hd7sUPA7SCJNWYlD1u3u9kfTEtkFwdUrNeYoi5xU=";
  };

  vendorSha256 = "sha256-89rSpxhP35wreo+0AqM+rDICCPchF+yFVvrTtZ2Xwr4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests = testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
