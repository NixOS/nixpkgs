{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.0-rc54";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-c9lMqHyOerqN32UCyM52EZm4t+MQLDibUOD8rBvIARA=";
  };

  vendorHash = "sha256-TKDOPs5kWOSXrDm6AadEF2PmSEzzrRyTMBWANZEr4cs=";

  ldflags = [
    "-X=main.Branch=main"
    "-X=main.Version=${version}"
    "-X=main.Revision=${src.rev}"
  ];

  # fails on darwin with: write unixgram -> <tmpdir>/rsyncd.log: write: message too long
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Tool for extracting metrics from application logs";
    homepage = "https://github.com/google/mtail";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "mtail";
  };
}
