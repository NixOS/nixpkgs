{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "url-parser";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "url-parser";
    rev = "v${version}";
    hash = "sha256-rOL6merwQ6CQkdsYGOpFttkJIy2EXCKMGIbAqqmYdvM=";
  };

  vendorHash = "sha256-ZaZlIGk44eX0ER2sdLdSvN2qdKVyEPsXjfCuJzJGspE=";

  ldflags = [
    "-s"
    "-w"
    "-X" "main.BuildVersion=${version}"
    "-X" "main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    description = "Simple command-line URL parser";
    homepage = "https://github.com/thegeeklab/url-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
