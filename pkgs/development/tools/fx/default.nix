{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "30.1.1";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-uKHh7ERxcIXmKY2NHichuyEIDu0MkeTs1f0jqark//E=";
  };

  vendorHash = "sha256-6wVcdzTYnB0Bd/YLPcbryKxCXu5genzQQ96znbn2ahw=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
