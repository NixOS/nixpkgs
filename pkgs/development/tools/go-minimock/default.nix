{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "sha256-l+ngvmTb9yVgQYT+OeaVd0zz/xNZeXWrjMpVkMpbQIw=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorSha256 = "sha256-hn222ifKRYbASAHBJyMTCDwhykf2Jg9IqIUlK/GabJA=";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
