{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G2mN7f5dpE6fF5ti7JJXVk8qBiwKO/yy5cyOYBxDJNo=";
  };

  vendorHash = "sha256-ux3nrQtY1sY4VJIeTSZAipfURspWDqnZ9YfxmFUvElI=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/reviewdog/reviewdog/commands.Version=${version}"
  ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    mainProgram = "reviewdog";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/blob/v${version}/CHANGELOG.md";
    maintainers = [ ];
    license = licenses.mit;
  };
}
