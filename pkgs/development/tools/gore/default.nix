{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gore";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uLU4uZaQA9u6BUQZ0Rb4Yqg/oJOZ529gIiOwmmyg05A=";
  };

  vendorSha256 = "sha256-/yggEibpQK9Uk116RkE5XbbJe6j4WsIC3GtKPU/P2hU=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
