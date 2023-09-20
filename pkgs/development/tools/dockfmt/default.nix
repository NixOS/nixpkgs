{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dockfmt";
  version = "unstable-2020-09-18";

  # The latest released version doesn't support reading from stdin.
  src = fetchFromGitHub {
    owner = "jessfraz";
    repo = "dockfmt";
    rev = "1455059b8bb53ab4723ef41946c43160583a8333";
    hash = "sha256-wEC9kENcE3u+Mb7uLbx/VBUup6PBnCY5cxTYvkJcavg=";
  };

  vendorSha256 = null;

  ldflags = [
    "-w"
    "-s"
    "-X github.com/jessfraz/dockfmt/version.VERSION=${version}"
  ];

  meta = with lib; {
    description = "Dockerfile format";
    homepage = "https://github.com/jessfraz/dockfmt";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
