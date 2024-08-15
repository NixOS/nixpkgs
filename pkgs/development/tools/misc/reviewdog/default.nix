{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Iu5jFSVg7I0i/GsSqAn90foaTG/6KmLMaqgna/0NOY0=";
  };

  vendorHash = "sha256-djM2nMwLG16NSBTZyovOvi0ZgzIMANAWhB+tAaqJ02Q=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [ "-s" "-w" "-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    mainProgram = "reviewdog";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${version}/CHANGELOG.md";
    maintainers = [ ];
    license = licenses.mit;
  };
}
