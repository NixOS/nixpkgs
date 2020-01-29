{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qn9hybqnhyf1xb6n0m4qq2ac8h187i2pjkkik73qly1hmyq45j7";
  };

  modSha256 = "037ihnvssgkzbg94yfw4lwqnhj02m187dfn1fm7i6yv13kf0gkpx";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
