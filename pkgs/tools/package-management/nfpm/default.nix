{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MRtmfRriHArmzSfSr4Wf3+2wA3sOlHZs2HKQ2d+Bd20=";
  };

  vendorHash = "sha256-UUpi/6R36g6ofnEmn/qxEeJlzM/INYD4FuvRaBZ6pss=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = with maintainers; [ marsam techknowlogick ];
    license = with licenses; [ mit ];
  };
}
