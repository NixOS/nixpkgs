{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JTHvLbJJOnQD9rW9GJ+7vtROMnpjgwD9Gu4cSf+ZIgs=";
  };

  vendorHash = "sha256-ADLBpTruCHgdi9+kO24ZguKJkxGDDKyrC60i7aiDA/4=";

  doCheck = false;

  subPackages = [ "cmd/reviewdog" ];

  ldflags = [ "-s" "-w" "-X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    changelog = "https://github.com/reviewdog/reviewdog/raw/v${version}/CHANGELOG.md";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
