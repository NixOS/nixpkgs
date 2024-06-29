{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZmkT6LDdAxYKjwKWxz+hKtmCq2u7R5X9Nn+DNIN3CZg=";
  };

  vendorHash = "sha256-hYS6i9G4rzw1zRxaKo1D5vxKVu+bEkJsoNhm9RD0nYU=";

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
