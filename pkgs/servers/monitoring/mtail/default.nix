{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-zIegPQEzG7qrvS40lDODw0oisZtMN5LnLdZA01K0FQs=";
  };

  vendorHash = "sha256-qn27BYQdYNfR+9w2SBfBzevtOLTm4Q6nwduL13TgmoY=";

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
