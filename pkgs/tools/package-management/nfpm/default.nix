{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KZeamXMhTX8CbPR66f4ij29GsIvzSbDUZtla+EXPRG4=";
  };

  vendorSha256 = "sha256-j4ebzVOzlmQwSkP8epDGClT7fhSUtC6uWdcoo+tFbnc=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
