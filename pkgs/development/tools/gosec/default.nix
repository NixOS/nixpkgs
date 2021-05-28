{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.8.0";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AC3NHW7LYbpZGA+iaM9eXFLothhqZuvRJM1ehBByhpk=";
  };

  vendorSha256 = "sha256-QfbElEjkYdmzYhQ8TOFIb2jfG2xzbW1UL2eLxROsBfw=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version} -X main.GitTag=${src.rev} -X main.BuildDate=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

