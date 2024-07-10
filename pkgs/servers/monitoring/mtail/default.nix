{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mtail";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
    hash = "sha256-+P21rrWgV9xbZV45Z2brb4F1p5qpaWLKgFqdhyhnkR8=";
  };

  vendorHash = "sha256-7u0r4AppzDpVulTPfI9K1njhHmu2kqESJXMjV3WKZFs=";

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
